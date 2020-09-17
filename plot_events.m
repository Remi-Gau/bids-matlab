function plot_events(path_to_bids)
    
    BIDS = bids.layout(path_to_bids);
    
    modalities = bids.query(BIDS, 'modalities');
    
    if ~any(strcmp(modalities, 'func'))
        fprintf(1, 'No functional file');
        return
    end
    
    tasks = bids.query(BIDS, 'tasks');
    
    for iTask = 1:numel(tasks)
        
        runs = bids.query(BIDS, 'runs', 'task', tasks{iTask});
        
        for iRun = 1:numel(runs)
            
            tsv_files = bids.query(BIDS, 'data', ...
                'task', tasks{iTask}, ...
                'run', runs{iRun}, ...
                'modality', 'func', ...
                'type', 'events');
            
            data = getData(tsv_files);
            
            data.task = tasks{iTask};
            data.run = runs{iRun};
            
            plotData(data)
            
        end
        
    end
    
end


function data = getData(tsv_files)
    
    
    for iData = 1:numel(tsv_files)
        
        content = bids.util.tsvread(tsv_files{iData});
        
        conditions = unique(content.trial_type);
        
        data(iData).conditions = conditions;
        
        for iCdt = 1:numel(conditions)
            
            idx = strcmp(content.trial_type, conditions{iCdt});
            data(iData).onsets{iCdt} = content.onset(idx); %#ok<*AGROW>
            data(iData).duration{iCdt} = content.duration(idx);
            
        end
        
    end
    
end


function plotData(data)
    
    figure('name', [data.task , ' - ', data.run])
    
    conditions = data.conditions;
    onsets = data.onsets;
    duration = data.duration;
    
    for iCdt = 1:numel(conditions)
        
        subplot(numel(conditions), 1, iCdt)
        
        if all(duration{iCdt}==0)
            stem(onsets{iCdt}, ones(1, numel(onsets{iCdt})))
        else
            
            for iStim=1:numel(onsets{iCdt})
                rectangle(...
                    'position', [onsets{iCdt}(iStim) 0 duration{iCdt}(iStim) 1], ...
                    'FaceColor', 'r')
            end
            
        end
        
        ylabel(strrep(conditions{iCdt}, '_', ' '))
        
    end
    
    subplot(numel(conditions), 1, 1)
    title([data.task , ' - ', data.run])
    
end