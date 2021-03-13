function resim = Wiener(ifbl, LEN, THETA, SNR, handle)
%Function to restore the image using Wiener Filter
%Inputs: ifbl, LEN, THETA, SNR.
%Returns: resim.
%
%ifbl:  It is the input image.
%THETA: It is the blur angle. The angle at which the image is blurred.
%LEN:   It is the blur length. The length is the number
%       of pixels by which the image is blurred.
%SNR:   It is the signal to noise ratio of the image.
%handle:It is the handle to the waitbar(progress bar).
%resim: It is the restored image.
%
%Example:
%       resim = Wiener(image, LEN, THETA, SNR);
%       This call takes image, blur length, blur angle & SNR as input
%       and returns the restored image.

%No of steps in the algorithm
steps = 8;

%Preprocessing
%Performing Median Filter before restoring the blurred image
ifbl = medfilt2(abs(ifbl));
waitbar(1/steps, handle);

%Converting to frequency domain
fbl = fft2(ifbl);
waitbar(2/steps, handle);

%Create PSF of degradation
PSF = fspecial('motion',LEN,THETA);
waitbar(3/steps, handle);

%Convert psf to otf of desired size
%OTF is Optical Transfer Function
%fbl is blurred image in frequency domain
OTF = psf2otf(PSF,size(fbl));
waitbar(4/steps, handle);

%Conjugate for modulus aquisition
OTFC = conj(OTF);
modOTF = OTF.*OTFC;
waitbar(5/steps, handle);

%To avoid divide by zero error
for i = 1:size(OTF, 1)
    for j = 1:size(OTF, 2)
        if OTF(i, j) == 0
            OTF(i, j) = 0.000001;
        end
    end
end
waitbar(6/steps, handle);

%Deblurring image using WEINER FILTER formula
debl = ((modOTF./(modOTF+SNR))./(OTF)).*fbl;
lbed = ifft2(debl);
waitbar(7/steps, handle);

%Restored image
resim = lbed;
waitbar(8/steps, handle);