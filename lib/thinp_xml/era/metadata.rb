module EraXML
  SUPERBLOCK_FIELDS = [[:uuid, :string],
                       [:block_size, :int],
                       [:nr_blocks, :int],
                       [:current_era, :int]]

  WRITESET_FIELDS = [[:era, :int],
                     [:nr_bits, :int],
                     [:bits, :array]]

  BIT_FIELDS = [[:block, :int],
                [:value, :bool]]

  def self.field_names(flds)
    flds.map {|p| p[0]}
  end

  Superblock = Struct.new(*field_names(SUPERBLOCK_FIELDS))
  Writeset = Struct.new(*field_names(WRITESET_FIELDS))
  WritesetBit = Struct.new(*field_names(BIT_FIELDS))
  Metadata = Struct.new(:superblock, :writesets, :era_array)
end
