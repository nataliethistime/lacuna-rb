# encoding: utf-8

# This table is used by the SendExcavators task to determine where excavators
# have been send in the past. Note that for this to work, the user needs
# to have auto resending of Excavators switched on.

unless LacunaUtil.db.table_exists? :excavator_locations
    LacunaUtil.db.create_table :excavator_locations do
        primary_key :id
        String :name, :null => false
        Integer :x, :null => false
        Integer :y, :null => false
        String :ore_type, :null => false
    end
end
