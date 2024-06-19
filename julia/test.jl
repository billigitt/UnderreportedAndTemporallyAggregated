# Import necessary packages
using CSV

function test(i::Int)
    # Load CSV file
    data = CSV.read("../CSVs/tester.csv")
    
    # Check if i is within range
    if !(1 <= i <= nrow(data))
        error("Index i out of range")
    end
    
    # Update the ith element and add 1
    newData = data[i, 1] + 1
    
    # Write the updated data to a new CSV file
    output_file = "updated_data$i.csv"
    CSV.write(output_file, newData)
    
    println("Updated data saved to $output_file")
end