# encoding: utf-8

# This is our data (taken from TLE docs):
# {
#     "body" : {
#         "id" : "id-goes-here",
#         "x" : -4,
#         "y" : 10,
#         "orbit" : 3,
#         "type" : "habitable planet",
#         "name" : "Earth",
#         "image" : "p13",
#         "size" : 67,
#         # This section only exists if an empire occupies it.
#         "empire" : {
#             "id" : "id-goes-here",
#             "name" : "Earthlings",
#             "alignment" : "ally", # Can be 'ally', 'self', or 'hostile'
#             "is_isolationist" : 1
#         }
#     }
# }

unless LacunaUtil.db.table_exists? :bodies
    LacunaUtil.db.create_table :bodies do
        primary_key :id
        String :name, :null => false
        Integer :x, :null => false
        Integer :y, :null => false
        Integer :size, :null => false
        Integer :orbit, :null => false
        String :type, :null => false
        String :ore_type, :null => false
        String :empire_id
        String :empire_name
        String :empire_alignment
        FalseClass :occupied, :default => false
    end
end
