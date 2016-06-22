function markers = prime(n)
  markers = ones(n-1, 1);

  i = 1;
  while i < n
    % Find next prime number
    while markers(i) ~= 1
      i = i + 1;
      if i > n-1
        break;
      end
    end

    % Initialize current prime and multiplier
    p = i + 1;
    m = p;

    % Mark all multiples of the current prime as not prime
    while m * p <= n
      markers(m * p - 1) = 0;
      m = m + 1;
    end

    i = i + 1;
  end
end
