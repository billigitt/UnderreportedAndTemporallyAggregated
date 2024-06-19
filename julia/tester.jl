try
    
    using CSV
    using DataFrames

catch

    import Pkg
    Pkg.add(["CSV", "DataFrames"])
end

using CSV
using DataFrames

# Load CSV file

idx = parse(Int64, ENV["SLURM_ARRAY_TASK_ID"])
#idx = 1

data = [1; 2; 3]

println("Hello!")

# Check if i is within range

# Update the ith element and add 1
newData = data .+ idx

df = DataFrame(
    x = newData
)

# Write the updated data to a new CSV file
output_file = "updated_data$idx.csv"
CSV.write(output_file, df)

println("Updated data saved to $output_file")
