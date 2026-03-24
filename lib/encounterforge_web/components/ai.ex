defmodule Encounterforge.AI do
  require IEx

  alias Encounterforge.Encounter

  def fetch_encounter(vibe) do
    api_key = System.get_env("OPENAI_API_KEY")
    url = "https://openrouter.ai/api/v1/chat/completions"

    headers = [
      {"HTTP-Referer", "http://localhost:4000"}, # site URL
      {"X-OpenRouter-Title", "Encounterforge"},  # site name
      {"Content-Type", "application/json"}       # site name
    ]

    body = %{
      model: "arcee-ai/trinity-mini:free",
      messages: [
        %{
          role: "user",
          content: """
          You are a D&D Master, playing a game of Dungeons & Dragons 5e.
          Create a story-driven encounter for the vibe: #{vibe}.
          Return only these keys:
          "title" (short evocative name, max 5 words),
          "location" (max 3 sentences),
          "monsters" (list of strings, e.g. ["3 Goblins"]),
          "motivation" (1 sentence),
          "twist" (1 sentence),
          "loot" (list of strings),
          "complication" (1 sentence).
          STRUCTURE THE RESPONSE LIKE THIS:

          {
            "title": "",
            "location": "",
            "monsters": [""],
            "motivation": "",
            "twist": "",
            "loot": [""],
            "complication": ""
          }

          BE CONCISE. NO MARKDOWN.
          """
        }
      ]
    }

    case Req.post(url, json: body, auth: {:bearer, api_key}, headers: headers) do
      {:ok, %{status: 200, body: body}} ->
        content = get_in(body, ["choices", Access.at(0), "message", "content"])
        {:ok, parse_json_response(content)}

      {:ok, %{status: status, body: body}} ->
        IO.inspect(body, label: "AI Error Body")
        {:error, "API Error: #{status}"}

      {:error, reason} ->
        {:error, "Network failure: #{reason}"}
    end
  end

  defp parse_json_response(content) do
    IO.puts("Raw AI Response:\n #{content} \n")

    content
    |> clean_markdown()
    |> Jason.decode!()
    |> then(fn data ->
      %Encounter{
        title: data["title"],
        location: data["location"],
        monsters: List.wrap(data["monsters"]) |> Enum.join(", "),
        motivation: data["motivation"],
        twist: data["twist"],
        loot: List.wrap(data["loot"]) |> Enum.join(", "),
        complication: data["complication"]
      }
    end)
  rescue
    _ -> %Encounter{location: "Error parsing JSON", monsters: content}
  end

  defp clean_markdown(content) do
    content
    |> String.replace(~r/^```json\s*|```\s*$/m, "")
    |> String.trim()
    |> close_json_string()
  end

  defp close_json_string(content) do
    if String.starts_with?(content, "{") and not String.ends_with?(content, "}") do
      content <> "}"
    else
      content
    end
  end
end
