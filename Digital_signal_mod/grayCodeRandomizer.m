function data = grayCodeRandomizer(num_of_bytes)
    % This function generates a random binary sequence where each consecutive pair of bits
    % forms a Gray code, i.e., only one bit changes from the previous pair.

    % Calculate the total number of bits
    num_bits = 8 * num_of_bytes;
    
    % Initialize the data array with zeros
    data = zeros(1, num_bits);
    
    % Start with a random pair of bits
    if num_bits >= 2
        data(1:2) = randi([0 1], 1, 2);
    end
    
    % Generate the rest of the bits
    for i = 3:2:num_bits
        % Select the previous pair
        previous_pair = data(i-2:i-1);
        
        % Choose a bit to toggle (1 or 2)
        bit_to_change = randi([1, 2]);
        
        % Copy previous pair to current position
        data(i:i+1) = previous_pair;
        
        % Toggle the selected bit
        data(i-1+bit_to_change) = 1 - previous_pair(bit_to_change);
    end
end
