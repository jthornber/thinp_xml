module CacheXML
  SUPERBLOCK_FIELDS = [[:uuid, :string],
                       [:block_size, :int],
                       [:nr_cache_blocks, :int],
                       [:policy_name, :string]]

  MAPPING_FIELDS = [[:cache_block, :int],
                    [:origin_block, :int]]

  HINT_FIELDS = [[:cache_block, :int],
                 [:encoded_data, :string]]

  def self.field_names(flds)
    flds.map {|p| p[0]}
  end

  Superblock = Struct.new(*field_names(SUPERBLOCK_FIELDS))
  Mapping = Struct.new(*field_names(MAPPING_FIELDS))
  Hint = Struct.new(*field_names(HINT_FIELDS))
  Metadata = Struct.new(:superblock, :mappings, :hints)
end
