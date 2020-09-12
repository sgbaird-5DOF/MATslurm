function uuid = get_uuid()
% GET_UUID  get unique ID (combination of 8 characters each of which can be
% a number or letter)
temp =  java.util.UUID.randomUUID;
uuidtmp = char(temp.toString);
uuid = uuidtmp(1:8);
end