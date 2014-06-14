# encoding: utf-8

# This is our data (taken from TLE docs):
# {
#     "stars" : [
#         {
#             "id" : "id-goes-here",
#             "color" : "yellow",
#             "name" : "Sol",
#             "x" : 17,
#             "y" : 4
#         }
#     ],
# }

unless LacunaUtil.db.table_exists? :stars
    LacunaUtil.db.create_table :stars do
        primary_key :id
        String :name, :null => false
        String :color, :null => false
        Integer :x, :null => false
        Integer :y, :null => false
    end
end
