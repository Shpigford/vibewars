module CollectionsHelper
  def trait_rarity(collection_total, trait_total)
    percentage = ((trait_total.to_f / collection_total.to_f) * 100).round(1)
    percentage.to_s + "%"
  end
end
