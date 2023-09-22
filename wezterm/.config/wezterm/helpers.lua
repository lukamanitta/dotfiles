local U = {}

function U.combine_tables(...)
    local combined = {}

    --- Loop through each table
    for _, tbl in ipairs({...}) do
      -- Copy the table into the combined table
      for k,v in pairs(tbl) do 
        combined[k]=v
      end
    end
  
    -- Return the combined table
    return combined
end


return U
