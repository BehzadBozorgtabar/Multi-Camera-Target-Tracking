function previewResults(dataset, trackerOutput)
close all;
fprintf('Displaying results...\n');

colors = distinguishable_colors(max(trackerOutput(:,1)));
%count = 1;
h = imshow([]);

myStart = dataset.startingFrame;
myEnd   = dataset.endingFrame;
fastfoward = 30;

for i = myStart : fastfoward : myEnd
    
    image  = readFrame(dataset,i + syncTimeAcrossCameras(dataset.camera));
    
    rows        = find(trackerOutput(:, 2) == i);
    identities  = trackerOutput(rows, 1);
    positions   = [trackerOutput(rows, 3),  trackerOutput(rows, 4), trackerOutput(rows, 5)-trackerOutput(rows, 3), trackerOutput(rows, 6)-trackerOutput(rows, 4)];
    
    if ~isempty(rows)
        frame = insertObjectAnnotation(image,'rectangle', ...
            positions, identities,'TextBoxOpacity', 0.8, 'FontSize', 13, 'Color', 255*colors(identities,:) );
    else
        frame = image;
    end

    
    % Tail
    rows = find((trackerOutput(:, 2) <= i) & (trackerOutput(:,2) >= i - 100));
    identities = trackerOutput(rows, 1);
    
    feetposition = [trackerOutput(rows,3),  trackerOutput(rows,6)];
    
  
    imshow(frame); hold on;
    scatter(feetposition(:, 1), feetposition(:, 2), 20, colors(identities,:), 'filled');
    hold off;
    drawnow;
    title(sprintf('Frame %d',i));
    drawnow;
    set(gcf,'PaperPositionMode','auto');

    
end

end

