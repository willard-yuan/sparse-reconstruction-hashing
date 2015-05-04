function im_out=num2img(num)
  
  load('digits');
  digit = squeeze(digit(:,:,1,:));
    
  s = num2str(num);
  if length(s)>5
    s = s(1:5); %% first few digits only
  end
  im_out = [];
  
  for a=1:length(s)
    
    asc = uint8(s(a));
    
    if (asc==46) & (a~=length(s))
      % point
      im_out = [ im_out , [255*ones(4,1);0] ];
    elseif (asc>=48) & (asc<=57)
      % digit
      im_out = [ im_out , digit(:,:,asc-47)];
    elseif (asc==45)
      % minus
      q = 255*ones(5,3); q(3,:)=0;
      im_out = [ im_out , q];     
    else
      % ignore
    end
    
    
    if (a~=length(s))
      im_out = [ im_out, 255*ones(5,1) ];
    end
    
  end

im_out=padarray(im_out,[1 1],255,'both');
im_out = uint8(repmat(im_out,[1 1 3]));  
