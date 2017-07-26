module ThinpXML
  SUPERBLOCK_FIELDS = [[:uuid, :string],
                       [:time, :int],
                       [:transaction, :int],
											 [:flags, :int],
											 [:version, :int],
                       [:data_block_size, :int],
                       [:nr_data_blocks, :int]]

  MAPPING_FIELDS = [[:origin_begin, :int],
                    [:data_begin, :int],
                    [:length, :int],
                    [:time, :int]]

  DEVICE_FIELDS = [[:dev_id, :int],
                   [:mapped_blocks, :int],
                   [:transaction, :int],
                   [:creation_time, :int],
                   [:snap_time, :int],
                   [:mappings, :object]]

  def self.field_names(flds)
    flds.map {|p| p[0]}
  end

  Superblock = Struct.new(*field_names(SUPERBLOCK_FIELDS))
  Mapping = Struct.new(*field_names(MAPPING_FIELDS))
  Device = Struct.new(*field_names(DEVICE_FIELDS))
  Metadata = Struct.new(:superblock, :devices)
end
