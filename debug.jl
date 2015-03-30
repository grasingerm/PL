macro NDEBUG()
  return true;
end

macro checkdebug(condition, message)
  if @NDEBUG()
    return;
  else
    return quote
      if !$condition
        warn($message);
      end
    end;
  end
end
