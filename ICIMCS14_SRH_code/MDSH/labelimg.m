function im_out=labelimg(im_in,labels)
  
  %im_out = im_in;
    
  nImg = size(im_in,4);
  
  im_out = zeros(size(im_in));
  
  if strcmp(class(im_in),'uint8')
    im_out = uint8(im_out);
  end
  
  
  for a=1:nImg
    
    limg = num2img(labels(a));
    [imy,imx,imz]=size(limg);
    tmp = im_in(:,:,:,a);
    tmp(1:imy,1:imx,1:imz) = limg;
    im_out(:,:,:,a) = tmp;
    
  end
