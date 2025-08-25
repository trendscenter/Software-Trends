function [Err,Par,RoiName]=CreateESRTM2(varargin)
%
% [Err,Par,RoiName]=CreateESRTM2([tacFN,[StartStopChlgTime,[SIFfn,Isotope]]])
%
%  Function that creates a txt file that can be imported into database with
%  the ESRTM2
%  estimate. If missing frames in the middle of time series then mean
%  estimate for previous/following frame is used, if missing info
%  before/after first/last frame info in first/last frame is used
% 
%  As High Bind TAC (used for ESRTM k2' estimation is used first time series
%  (column 3 in tac file)) and as Ref TAC is used last column in tac file
%
%  vargin is evaluated as:
% 
% tacFN    - *.tac file from CreatePMODtac_?, contains infor about regions
%            and timing (timing should be in sec)
% StartStopChlgTime     - structure with time information of which datapoints to use (or 
%            length of time for fitting), and eventually where challenge is
%            all of them specified in seconds. If empty then they are
%            attumaticllay decided from tac file, challenge in the middle
%    Time.Start - Start time for fitting
%    Time.Stop  - Stop time for fitting
%    Time.Delta - How long time used for fitting (ignored if Start 
%                 and Stop given)
%    Time.Chlng - Challenge time (for ESRTM/ESRTM2) else ignored
% SIFfn    - SIF file with prompts and randoms information
% Isotope  - 'C11', 'F18', 'O15', 'I123' (alternative half life of isotope
%            can be given - in minutes)
%
% CS, 20140826
%

%
% Redo plot with selected regions
%
if (nargin==1)&&strcmp(varargin{1},'ShowROIs')
    ShowROIs;
    return
end
%
% Evaluate input parameters
%
[TimeTAC,Weights,RefTAC,RoiTAC,Name,ExtPar,DocTxt]=KinmodEvaluateInpArg('CreateESRTM2',varargin{:});
RoiName=Name.Roi;
%
NameHighBind.Roi{1}=Name.Roi{1};
HighBindTAC=RoiTAC(:,1);

%
% Estimate k2' using SRTM
%
[Err_srtm,Par_srtm,yest_srtm,Par_cov_srtm,LogLike_srtm,AIC_srtm,MSE_srtm,FPE_srtm]=...
    esrtm_estm(TimeTAC,Weights,RefTAC,HighBindTAC,NameHighBind,ExtPar.Chlng);
k2p=Par_srtm{1}(2)/Par_srtm{1}(1);
k2p_cov=(Par_cov_srtm{1}(2,2)*Par_srtm{1}(1)^2-2*Par_cov_srtm{1}(1,2)*Par_srtm{1}(1)*Par_srtm{1}(2)+...
    Par_cov_srtm{1}(1,1)*Par_srtm{1}(2)^2)/Par_srtm{1}(1)^4;
%k2p=Par_srtm{1}(2);
%k2p_cov=Par_cov_srtm{1}(2,2);
%
% Estimate parameters
%
[Err,Par,yest,Par_cov,LogLike,AIC,MSE,FPE]=esrtm2_estm(TimeTAC,Weights,RefTAC,RoiTAC,Name,ExtPar.Chlng,k2p);
%
% Visualize and save output
%
DataTAC.Time=TimeTAC;
DataTAC.Ref=RefTAC;
DataTAC.Roi=RoiTAC;
DataTAC.RoiEst=yest;
DataTAC.TimeChlng=ExtPar.Chlng;
MakePlot(DataTAC,Name,-1);
%
% Print data to screen and file
%
fprintf('\n\nData for ESRTM2 model\n\n');
fprintf('   Data from %s\n\n',Name.Label');
for i=1:size(RoiTAC,2)
    fprintf('   ESRTM2: %s: k2''=%5.3f, R1=%5.3f, BPnd0=%5.3f, BPnd1=%5.3f, WeightErr: %6.2e, MSE: %6.2e, FPE: %6.2e, LogLikelihood: %6.3e, AIC: %6.2e\n',...
        Name.Roi{i},k2p,Par{i},Err(i), MSE(i),FPE(i),LogLike(i),AIC(i));
end
%
[pn,fn,ext]=fileparts(Name.Label);
print('-djpeg','-r300',fn);
%
% Save data to file
%
[pn,fn,ext]=fileparts(Name.Label);
pid=fopen([fn '.esrtm2'],'w');
if pid==-1
    warning('ESRTM2: not possible to open file for saving ESRTM2 results - probably write protected directory\n\n');
else
    %
    % Document date user and so on
    %
    for i=1:length(DocTxt)
        fprintf(pid,'%s',DocTxt{i});
    end
    %
    % Write data
    %
    fprintf(pid,'ESRTM2\tk2''\tR1\tBPnd0\tBPnd1\tMSE\tLogLikelihood\tAIC\t%%Cov k2''\t%%Cov R1\t%%Cov BPnd0\t%%Cov BPnd1\n');
    for i=1:size(RoiTAC,2)
        fprintf(pid,'%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\n',...
            Name.Roi{i},k2p,Par{i},MSE(i),LogLike(i),AIC(i),sqrt(k2p_cov)/k2p*100,sqrt(diag(Par_cov{i}))./Par{i}'*100);
    end
    fclose(pid);
end


    function MakePlot(DataTAC,Name,ROIs)
        %
        fig_h=findobj('type','figure','tag','CreateESRTM2fig');
        if ROIs==-1
            New=1;
            delete(fig_h);
        else
            New=0;
        end
        if (nargin==2)||New==1
            ROIs=1:size(DataTAC.Roi,2);
        end
        %
        if isempty(fig_h)||New==1
            h=figure;
            set(h,'tag','CreateESRTM2fig');
            ud.Data=DataTAC;
            ud.Name=Name;
            set(h,'UserData',ud);
            mh=uimenu(h,'Label','ESRTM2');
            seh1=uimenu(mh,'Label','Select ROIs','Accelerator','S','CallBack','CreateESRTM2(''ShowROIs'');');
        else
            ud=get(fig_h,'UserData');
            DataTAC=ud.Data;
            Name=ud.Name;
        end
        subplot(211),plot(DataTAC.Time,DataTAC.Roi(:,ROIs),'*',DataTAC.Time,DataTAC.Ref,'+');
        hold on
        d=ver('matlab');
        if (d.Version(1)>'8')
            set(gca,'ColorOrderIndex',1);
        end
        plot(DataTAC.Time,[DataTAC.RoiEst(:,ROIs), DataTAC.Ref]);
        grid
        yl=get(gca,'YLim');
        plot([1 1]*DataTAC.TimeChlng,yl,'-.m') 
        hold off
        xlabel('Time [min]');
        ylabel('Activity [Bq/cc]')
        h=title(sprintf('ESRTM2 fit: %s (%s)' ,Name.Label,datestr(clock,0)));
        set(h,'interpreter','none');
        ha1=gca;
        %
        subplot(212),plot(DataTAC.Time,DataTAC.Roi(:,ROIs)-DataTAC.RoiEst(:,ROIs));
        xlabel('Time [min]');
        ylabel('Residuals: Activity [Bq/cc]')
        ha2=gca;
        grid
        hold on
        yl=get(gca,'YLim');
        plot([1 1]*DataTAC.TimeChlng,yl,'-.m') 
        hold off
        %
        if length(ROIs)<16    % More than 16 ROI's then not possible to do legend
            nn=Name.Roi(ROIs);
            nn{end+1}=Name.Ref;
            hl=legend(ha1,nn,'Location','EastOutside');
            h=findobj('type','text');
            set(h,'fontsize',8);
            set(h,'interpreter','none');
            %
            %newPosition = [0.4 0.4 0.2 0.2];
            %newUnits = 'normalized';
            %set(hl,'Position', newPosition,'Units', newUnits);
            pos1=get(ha1,'Position');
            pos2=get(ha2,'Position');
            pos2(3)=pos1(3);
            %set(ha1,'Position',pos1);
            set(ha2,'Position',pos2);
            %
            pos_l=get(hl,'Position');
            pos_l(3)=pos_l(3)*1.2;
            pos_l(2)=0.5-0.5*pos_l(4);
            set(hl,'Position',pos_l);
            %
            set(ha1,'Position',pos1);
        end
        
        h=findobj('type','text');
        set(h,'interpreter','none');
    end

    function ShowROIs
        fig_h=findobj('type','figure','tag','CreateESRTM2fig');
        ud=get(fig_h,'UserData');
        DataTAC=ud.Data;
        Name=ud.Name;
        %
        [s,v] = listdlg('PromptString','Select ROIs:',...
            'SelectionMode','multiple',...
            'ListString',Name.Roi);
        %
        MakePlot(DataTAC,Name,s);
    end
end
