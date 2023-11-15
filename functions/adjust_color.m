function  out=adjust_color(varargin)
% This function modifies an input color to fit a dark theme background.
% For that a color needs to have sufficient contrast (WCAG's AA standard of at least 4.5:1)
% The contrast ratio is calculate via :  cr = (L1 + 0.05) / (L2 + 0.05),
% where L1 is the relative luminance of the input color and L2 is the
% relative luminance of the dark mode background.
% For this case we will assume a dark mode theme background of...
% If a color is not passing this ratio, it will be modified to meet it
% via desaturation and brightness to be more legible.
% the function uses fminbnd, if you dont have the toolbox to use it you can
% replace it with fmintx (avaiable in Matlab's file exchange)

if nargin==1
    in = varargin{1};
    tcd= {[1 1 1],4.5,[0.16 0.16 0.16]};
    alpha=1;
elseif nargin==2
    in = varargin{1};
    tcd= varargin{2};
    alpha=1;
elseif nargin==3
    in = varargin{1};
    tcd= varargin{2};
    alpha= varargin{3};

end


% if color is 'none' return as is
if strcmp(in,'none')
    out=in;
    return
end

if isa(in,'char') % for inputs such as 'flat', 'auto', etc...
    out=in;
    return
end

dark_bkg_assumption=tcd{3};

% the apparent color will be a combination of the original color and
% the bkg behind it given the alpha value.
in=in.*alpha+(1-alpha).*dark_bkg_assumption;



% find the perceived lightness which is measured by some vision models
% such as CIELAB to approximate the human vision non-linear response curve.
% 1. linearize the RGB values (sRGB2Lin)
% 2. find Luminance (Y)
% 3. calc the perceived lightness (Lstar)
% Lstar is in the range 0 to 1 where 0.5 is the perceptual "middle gray".
% see https://en.wikipedia.org/wiki/SRGB ,

sRGB2Lin=@(in) (in./12.92).*(in<= 0.04045) +  ( ((in+0.055)./1.055).^2.4 ).*(in> 0.04045);
%Y = @(in) sum(sRGB2Lin(in).*[0.2126,  0.7152,  0.0722 ]);
Y = @(in) sum(bsxfun(@times,sRGB2Lin( in ),[0.2126,  0.7152,  0.0722 ]),2 );
Lstar = @(in)  0.01.*( (Y(in).*903.3).*(Y(in)<= 0.008856) + (Y(in).^(1/3).*116-16).*(Y(in)>0.008856));

Ybkg = sum(sRGB2Lin(dark_bkg_assumption).*[0.2126,  0.7152,  0.0722 ]);

cr = @(in)   (Y(in)' + 0.05) ./ (Ybkg + 0.05); % contrast ratio

% rgb following desaturation of factor x
ds=@(in,x) hsv2rgb( bsxfun(@times,rgb2hsv(in),[ones(numel(x),1) x(:) ones(numel(x),1)] ));

% rgb following brightness change of factor x
br=@(in,x) hsv2rgb( bsxfun(@power,rgb2hsv(in),[ones(numel(x),1) ones(numel(x),1) x(:)] ));


if cr(in)<tcd{2} % default is 4.5

    %check if color is just black and replace with perceptual "middle gray"
    if ~sum(in)
        fun0 = @(x) abs(Lstar( (ones(1,3)*x-dark_bkg_assumption ))-0.5);
        L_factor=fminbnd(fun0,0.3,1);

        out = ones(1,3)*L_factor;
        return

    end


    % if saturation is what reduce contrast then desaturate
    in_hsv=rgb2hsv(in);
    if in_hsv(2)>0.5

        fun1=@(x) abs(cr(ds(in,x))-tcd{2});
        [ds_factor, val]=fminbnd(fun1,0,in_hsv(2));

        if val<1e-2
            out = ds(in,ds_factor);
            return
        end
    end

    % desaturation alone didn't solve it, try to increase brightness
    fun2 =  @(x) abs(cr(br(in,x))-tcd{2});
    [br_factor, val]=fminbnd(fun2,0,1);

    if val<1e-2 && Lstar(br(in,br_factor))>0.5
        out = br(in,br_factor);
        return
    end

    % if niether worked then brightening + desaturation:
    fun3 = @(x) abs(cr(ds(br(in,br_factor),x))-tcd{2});
    [brds_factor, val]=fminbnd(fun3,0,1);

    if val<1e-2 && Lstar(ds(br(in,br_factor),brds_factor))>0.5
        out = ds(br(in,br_factor),brds_factor);
        return

    end

    % if all fails treat the color as black as above:
    fun0 = @(x) abs(Lstar( (ones(1,3)*x-dark_bkg_assumption ))-0.5);
    L_factor=fminbnd(fun0,0.3,1);
    out = ones(1,3)*L_factor;

else
    out = in ;
end
end