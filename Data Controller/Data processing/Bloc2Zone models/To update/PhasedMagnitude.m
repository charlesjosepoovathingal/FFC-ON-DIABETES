classdef PhasedMagnitude < Bloc2Zone & ProcessDataUnit
    
    properties
        InputChildClass@char; 	% defined in DataUnit2DataUnit
        OutputChildClass@char;	% defined in DataUnit2DataUnit
        functionName@char = 'Average of rephased signal';
        labelY@char = 'Average signal (A.U.)'; 
        labelX@char = 'Evolution time (s)';  
        legendTag@cell = {'AbsRephased'}; 
    end
        
    methods
        % Constructor
        function this = PhasedMagnitude
            % call both superclass constructor
            this = this@Bloc2Zone;
            this = this@ProcessDataUnit;
            % set the ForceDataCat flag to true. Allow to get all the 3D
            % bloc matrix.
            % Warning: output data should be formated as:
            % new_data.x = NBLK x BRLX matrix
            % new_data.y = NBLK x BRLX matrix
            % ...
            %
            this.ForceDataCat = true;
        end % AverageAbs
        
        % Define abstract method applyProcess(). See ProcessDataUnit.
        function [model, new_data] = applyProcess(this, data)
            % get data size
            [~, NBLK, BRLX] = size(data.y);
            
            % get absolute y-values and replace unwanted values by nan (masked).
            y = abs(data.y);
            y((y == data.mask)) = nan;
            
            
            % estimation of the phase (using the entire zone)
            if index(1)==1
                sigPh = median(angle(squeeze(bloc.y(4:10,:,index(2)))));
                [~,indexJump] = max(abs(diff(sigPh))); % find where the phase changes using the first 10 points or so
                ph = (1:size(bloc.y,2))<=indexJump;
                bloc.parameter.paramList.phasingArray(:,index(2)) = ph;
            else
                ph = bloc.parameter.paramList.phasingArray(:,index(2));
            end
            
            
            % apply absolute average on the first dimension and avoid nan
            % values. Reshape to get NBLK x BRLX matrix
            new_data.y = reshape(mean(y,1,'omitnan'),[NBLK, BRLX]);
            new_data.dy = reshape(std(y,[],1,'omitnan'),[NBLK, BRLX]);
        end %applyProcess
        
        
%         function [z,dz,paramFun] = process(self,x,y,bloc,index) %#ok<*INUSD,*INUSL>
%             % getting the phase of the signal
% %             [~,ord] = sort(x);
% %             y = y(ord);
%             
%             % find the global parameters 
%             if isequal(index,[1 1])
%                 sze = size(bloc.y);
%                 indexSignal = min(20,ceil(sze(1)/10));
%                 Y = fft(bloc.y,[],1);
%                 Y([1:indexSignal end-indexSignal:end],:,:) = 0;
%                 noise = ifft(Y,[],1);
%                 bloc.parameter.paramList.noise = std(real(noise(indexSignal:end-indexSignal))); % estimation of the noise level
%             end
%             noise = bloc.parameter.paramList.noise;
%             
% %             yf = MRI_lmmse(abs(y),[1 1],'sigma',noise); % Rician filter
% %             y = median(yf);
%             
%             % Rician filter
%             y = abs(y);
%             indp = y > noise;
%             y(indp) = sqrt(y(indp).^2 - noise^2) - noise;
%             indn = y <= noise;
%             y(indn) = (y(indn).^2 -2*noise^2)/(2*noise);
%             
%             y = median(y);
%             
% %             if y > noise
% %                 y = sqrt(y.^2 - noise^2) - noise;  % TO DO: stochastic filter
% %             else
% %                 y = (y^2 -2*noise^2)/(2*noise);
% %             end
%             
%             % estimation of the phase (using the entire zone)
%             if index(1)==1
%                 sigPh = median(angle(squeeze(bloc.y(4:10,:,index(2)))));
%                 [~,indexJump] = max(abs(diff(sigPh))); % find where the phase changes using the first 10 points or so
%                 ph = (1:size(bloc.y,2))<=indexJump;
%                 bloc.parameter.paramList.phasingArray(:,index(2)) = ph;
%             else
%                 ph = bloc.parameter.paramList.phasingArray(:,index(2));
%             end
%             
% %             yzone = squeeze(bloc.y(:,:,index(2)));
% %             phi = unwrap(angle(yzone));
% % %             yzonem = mean(yzone,2);
% % %             mask = abs(yzonem)>(max(abs(yzonem))/2);
% % %             dphi = diff(phi(mask,:))./repmat(diff(x(mask)),1,size(yzone,2));
% % %             a = median(dphi);
% % %             b = median(phi(mask,:)-x(mask)*a);
% % %             b = b - b(1);
% %             b = phi(4,:);
% %             b = b - b(1);
%             
%             
%             
%             if ph(index(1))
%                 z = median(y);
%             else
%                 z = -median(y);
%             end
%             dz = noise;
%             % need to initialise the parameter object to avoid problems
%             paramFun.test = index;
%         end
    end
end
