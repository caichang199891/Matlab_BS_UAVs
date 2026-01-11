function h = rnghash(seed)
%RNGHASH Simple hash from seed
h = mod(seed * 2654435761, 2^32);
end
