defmodule Encounterforge.Encounter do
  defstruct [:title, :location, :monsters, :motivation, :twist, :loot, :complication]

  def generate_mock do
    %__MODULE__{
      title: "The Whispering Hollow",
      location: "A dark and eerie forest where ancient trees creak and groan, their gnarled roots hiding forgotten pathways. The air is thick with mist and the faint sound of whispers can be heard on the wind.",
      monsters: "3 Giant Spiders",
      motivation: "The spiders are guarding their eggs and will attack if disturbed",
      twist: "The monsters are actually cursed villagers seeking help",
      loot: "A hidden treasure chest filled with gold and magical items",
      complication: "A sudden rock slide makes the terrain treacherous"
    }
  end
end
