function resim = Lucy(ifbl, LEN, THETA, iterations, handle)
%Function to restore the image using Lucy-Richardson
%Inputs: ifbl, LEN, THETA, iterations.
%Returns: resim
%
%ifbl:  It is the input image.
%THETA: It is the blur angle. The angle at which the image is blurred.
%LEN:   It is the blur length. The length is the number
%       of pixels by which the image is blurred.
%iterations: It is the number of iterations.
%handle:It is the handle to the waitbar(progress bar).
%resim: It is the restored image.
%
%Example:
%       resim = Lucy(image, LEN, THETA, iterations);
%       This call takes image, blur length, blur angle & no. of iterations 
%       as input and returns the restored image

%Preprocessing
%Performing Median Filter before restoring the blurred image
ifbl = medfilt2(abs(ifbl));

%Initialising the initial estimate to the blurred image
est = ifbl;

%Create PSF of degradation
PSF = fspecial('motion',LEN,THETA);

%Convert psf to otf of desired size
%OTF is Optical Transfer Function
OTF = psf2otf(PSF,size(ifbl));

i = 1;
while i<=iterations
    %Converting the estimate to frequency domain
    fest = fft2(est);
    
    %Multiplying OTF with the estimate in frequency domain
    fblest = OTF.*fest;
    
    %Converting the blurred image estimate to spatial domain
    ifblest = ifft2(fblest);
    
    %Calculating ratio of blurred image and estimate of the deblurred image
    iratio = ifbl./ifblest;
    
    %Converting the ratio to frequency domain
    firatio = fft2(iratio);
    
    %Calculating the correction vector
    corrvec = OTF .* firatio;
    
    %Converting the correction vector to spatial domain
    icorrvec = ifft2(corrvec);
    
    %Multiplying correction vector & estimate of deblurred image to find next estimate
    aftercorr = icorrvec.*est;
    est = aftercorr;

    %Setting the waitbar indicating how much is completed
    waitbar(i/iterations, handle);
    i = i+1;
end

%Restored image
resim = abs(est);