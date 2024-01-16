import pandas as np

def importfile(filename, startRow=5, endRow=float('inf')):
    # Initialize variables
    delimiter = ';'

    # Open the text file
    with open(filename, 'r') as fileID:
        # Read columns of data according to the format
        dataArray = []
        for i in range(startRow - 1):
            next(fileID)
        for line in fileID:
            dataArray.append(line.strip().split(delimiter))

    # Convert the contents of columns containing numeric text to numbers
    raw = [['' for _ in range(len(dataArray[0]))] for _ in range(len(dataArray))]
    numericData = [[np.nan for _ in range(len(dataArray[0]))] for _ in range(len(dataArray))]

    for row in range(len(dataArray)):
        for col in range(len(dataArray[row])):
            try:
                numbers = float(dataArray[row][col].replace(',', ''))
                numericData[row][col] = numbers
                raw[row][col] = numbers
            except ValueError:
                raw[row][col] = dataArray[row][col]

    # Replace non-numeric cells with 0.0
    for row in range(len(raw)):
        for col in range(len(raw[row])):
            if not isinstance(raw[row][col], (int, float)):
                raw[row][col] = 0.0

    # Create output variable
    meta = np.array(raw, dtype=float)
    return meta
