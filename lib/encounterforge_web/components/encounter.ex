defmodule Encounterforge.Encounter do
  defstruct [:location, :monsters, :motivation, :twist, :loot, :complication]

  def generate_mock do
    %__MODULE__{
      location: "A dark and eerie forest",
      monsters: "3 Giant Spiders",
      motivation: "The spiders are guarding their eggs and will attack if disturbed",
      twist: "The monsters are actually cursed villagers seeking help",
      loot: "A hidden treasure chest filled with gold and magical items",
      complication: "A sudden rock slide makes the terrain treacherous"
    }
  end
end
