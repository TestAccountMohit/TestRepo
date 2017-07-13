function [] = plotStuff(Allsigs)

% added one more line of comment morejjj
%% ok me try what you say
% fix scaling
[scaling]= scaleStuff(Allsigs);
disp('Hypped')

% plot
fig1=figure;
colMap=hsv(size(Allsigs,1));
hold on
grid on
for x=1:size(Allsigs,1)
    data=evalin('base',[Allsigs{x} '.signals.values']);
    time=evalin('base',[Allsigs{x} '.time']);
    plot(time,data*scaling(x),'col',colMap(x,:),'LineWidth',2)
end


%% proper legend
maxScale=ceil(log10(max(scaling(:))))+1;
strngForLegPartScale=num2str(scaling,['%0' num2str(maxScale) 'd']);
strngForLegPartScale=strcat (strngForLegPartScale,' *  ');
legend(strcat(strngForLegPartScale,strrep(Allsigs,'_','\_')))


%% its better to scale everything
    function [scaling]= scaleStuff(Allsigs)
        range=zeros(size(Allsigs,1),2);
        for xx=1:size(Allsigs,1)
            values=evalin('base',[Allsigs{xx} '.signals.values']);
            if max(values)-min(values)== 0
                % its a constant value
                if max(values)==0 && min(values)== 0
                    % constant always zero
                    range(xx,1)=0;
                    range(xx,2)=1;
                else
                    % constant non zero
                    range(xx,1)=0;
                    range(xx,2)=max(abs(values));
                    
                end
                
            else
                range(xx,1)=min(values);
                range(xx,2)=max(values);
            end
            
            
            
        end
        
        absRange=[min(range(:)) max(range(:))];
        absRangDiff=absRange(2)-absRange(1);
        absRangDiff=roundoff(absRangDiff,@floor);
        
        scaling=absRangDiff./(range(:,2) - range(:,1));
        scaling=roundoff(scaling./10,@ceil); %% divide by 10 to stay at absoulte max range scale.
        
        %% small roundoff Functions
        function [roundedOff] = roundoff(inputNum,funcDyn)
            pR=funcDyn(log10(inputNum));
            roundedOff=ceil(inputNum./10.^pR).*10.^(pR);
            
        end
        
    end


    


end
