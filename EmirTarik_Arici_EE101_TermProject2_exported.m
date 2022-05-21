classdef EmirTarik_Arici_EE101_TermProject2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        EditField_2                 matlab.ui.control.EditField
        DurationSlider              matlab.ui.control.Slider
        DurationLabel               matlab.ui.control.Label
        EditField                   matlab.ui.control.EditField
        MagnifyKnob                 matlab.ui.control.Knob
        MagnifyKnobLabel            matlab.ui.control.Label
        SpeedKnob                   matlab.ui.control.Knob
        SpeedKnobLabel              matlab.ui.control.Label
        Switch                      matlab.ui.control.RockerSwitch
        PlayManipulatedAudioButton  matlab.ui.control.Button
        PlayOriginalAudioButton     matlab.ui.control.Button
        RecordButton                matlab.ui.control.Button
        TimeDomain                  matlab.ui.control.UIAxes
        FrequencyDomain             matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RecordButton
        function RecordButtonPushed(app, event)
            audioObject = audiorecorder;
            duration = app.DurationSlider.Value;
            msgbox("Recording... Press OK.");
            
            recordblocking(audioObject,duration);
            msgbox("Recording Completed. Press OK");

            % Time domain
            y = getaudiodata(audioObject);
            Fs = audioObject.SampleRate;
            t = linspace(0,length(y)/Fs,length(y));
            
            plot(app.TimeDomain,t,y);

            % Frequency Domain
            nfft = audioObject.TotalSamples;
            f = linspace(0,Fs,nfft);
            Y = abs(fft(y,nfft));
            
            plot(app.FrequencyDomain,f(1:nfft/2), Y(1:nfft/2));
            
            assignin("base","audioObject",audioObject);

            
        end

        % Button pushed function: PlayManipulatedAudioButton
        function manipulatedPlayButtonPushed(app, event)
            audioObject = evalin("base","audioObject");

            y = getaudiodata(audioObject);
            Fs = audioObject.SampleRate;
            
            % Speed Function
            speed = app.SpeedKnob.Value;
            % Magnify Function
            magnify = app.MagnifyKnob.Value;
            
            % Reverse Function
            if app.Switch.Value == "Reverse"
                z = flipud(y);
                y = z;
            end
            
            % Sound manipulation
            sound(y * magnify, Fs * speed);

            play(audioObject);
        end

        % Button pushed function: PlayOriginalAudioButton
        function originalPlayOriginalAudioButtonPushed(app, event)
            audioObject = evalin("base","audioObject");

            y = getaudiodata(audioObject);
            Fs = audioObject.SampleRate;

            sound(y,Fs);

            play(audioObject);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 737 534];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50};
            app.GridLayout.RowHeight = {60, 60, 60, 60, 60, 61, 60, '1x'};
            app.GridLayout.BackgroundColor = [0.502 0.502 0.502];

            % Create FrequencyDomain
            app.FrequencyDomain = uiaxes(app.GridLayout);
            title(app.FrequencyDomain, 'Frequency Domain')
            xlabel(app.FrequencyDomain, 'Frequency')
            ylabel(app.FrequencyDomain, 'Amplitude')
            zlabel(app.FrequencyDomain, 'Z')
            app.FrequencyDomain.AmbientLightColor = [0.902 0.902 0.902];
            app.FrequencyDomain.XColor = [0.902 0.902 0.902];
            app.FrequencyDomain.YColor = [0.902 0.902 0.902];
            app.FrequencyDomain.ZColor = [0.902 0.902 0.902];
            app.FrequencyDomain.Color = [0.902 0.902 0.902];
            app.FrequencyDomain.GridColor = [0.15 0.15 0.15];
            app.FrequencyDomain.MinorGridColor = [0.9412 0.9412 0.9412];
            app.FrequencyDomain.Layout.Row = [1 5];
            app.FrequencyDomain.Layout.Column = [7 12];

            % Create TimeDomain
            app.TimeDomain = uiaxes(app.GridLayout);
            title(app.TimeDomain, 'Time Domain')
            xlabel(app.TimeDomain, 'Time')
            ylabel(app.TimeDomain, 'Amplitude')
            zlabel(app.TimeDomain, 'Z')
            app.TimeDomain.XColor = [0.902 0.902 0.902];
            app.TimeDomain.YColor = [0.902 0.902 0.902];
            app.TimeDomain.ZColor = [0.902 0.902 0.902];
            app.TimeDomain.Color = [0.902 0.902 0.902];
            app.TimeDomain.GridColor = [0.902 0.902 0.902];
            app.TimeDomain.MinorGridColor = [0.902 0.902 0.902];
            app.TimeDomain.Layout.Row = [1 5];
            app.TimeDomain.Layout.Column = [1 6];

            % Create RecordButton
            app.RecordButton = uibutton(app.GridLayout, 'push');
            app.RecordButton.ButtonPushedFcn = createCallbackFcn(app, @RecordButtonPushed, true);
            app.RecordButton.BackgroundColor = [0.6353 0.0784 0.1843];
            app.RecordButton.FontColor = [0.902 0.902 0.902];
            app.RecordButton.Layout.Row = 6;
            app.RecordButton.Layout.Column = 1;
            app.RecordButton.Text = 'Record';

            % Create PlayOriginalAudioButton
            app.PlayOriginalAudioButton = uibutton(app.GridLayout, 'push');
            app.PlayOriginalAudioButton.ButtonPushedFcn = createCallbackFcn(app, @originalPlayOriginalAudioButtonPushed, true);
            app.PlayOriginalAudioButton.BackgroundColor = [0.4667 0.6745 0.1882];
            app.PlayOriginalAudioButton.FontColor = [0.9412 0.9412 0.9412];
            app.PlayOriginalAudioButton.Layout.Row = 6;
            app.PlayOriginalAudioButton.Layout.Column = [2 4];
            app.PlayOriginalAudioButton.Text = 'Play Original Audio';

            % Create PlayManipulatedAudioButton
            app.PlayManipulatedAudioButton = uibutton(app.GridLayout, 'push');
            app.PlayManipulatedAudioButton.ButtonPushedFcn = createCallbackFcn(app, @manipulatedPlayButtonPushed, true);
            app.PlayManipulatedAudioButton.BackgroundColor = [0.4667 0.6745 0.1882];
            app.PlayManipulatedAudioButton.FontColor = [0.9412 0.9412 0.9412];
            app.PlayManipulatedAudioButton.Layout.Row = 6;
            app.PlayManipulatedAudioButton.Layout.Column = [5 7];
            app.PlayManipulatedAudioButton.Text = 'Play Manipulated Audio';

            % Create Switch
            app.Switch = uiswitch(app.GridLayout, 'rocker');
            app.Switch.Items = {'Straight', 'Reverse'};
            app.Switch.FontColor = [0.9412 0.9412 0.9412];
            app.Switch.Layout.Row = [6 8];
            app.Switch.Layout.Column = 12;
            app.Switch.Value = 'Straight';

            % Create SpeedKnobLabel
            app.SpeedKnobLabel = uilabel(app.GridLayout);
            app.SpeedKnobLabel.HorizontalAlignment = 'center';
            app.SpeedKnobLabel.FontColor = [0.9412 0.9412 0.9412];
            app.SpeedKnobLabel.Layout.Row = 8;
            app.SpeedKnobLabel.Layout.Column = [10 11];
            app.SpeedKnobLabel.Text = 'Speed';

            % Create SpeedKnob
            app.SpeedKnob = uiknob(app.GridLayout, 'continuous');
            app.SpeedKnob.Limits = [0 2];
            app.SpeedKnob.MinorTicks = [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2];
            app.SpeedKnob.Layout.Row = [6 7];
            app.SpeedKnob.Layout.Column = [10 11];
            app.SpeedKnob.FontColor = [0.9412 0.9412 0.9412];
            app.SpeedKnob.Value = 1;

            % Create MagnifyKnobLabel
            app.MagnifyKnobLabel = uilabel(app.GridLayout);
            app.MagnifyKnobLabel.HorizontalAlignment = 'center';
            app.MagnifyKnobLabel.FontColor = [0.9412 0.9412 0.9412];
            app.MagnifyKnobLabel.Layout.Row = 8;
            app.MagnifyKnobLabel.Layout.Column = [8 9];
            app.MagnifyKnobLabel.Text = 'Magnify';

            % Create MagnifyKnob
            app.MagnifyKnob = uiknob(app.GridLayout, 'continuous');
            app.MagnifyKnob.Limits = [0 40];
            app.MagnifyKnob.MajorTicks = [0 5 10 15 20 25 30 35 40];
            app.MagnifyKnob.MajorTickLabels = {'0', '5', '10', '15', '20', '25', '30', '35', '40', ''};
            app.MagnifyKnob.MinorTicks = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40];
            app.MagnifyKnob.Layout.Row = [6 7];
            app.MagnifyKnob.Layout.Column = [8 9];
            app.MagnifyKnob.FontColor = [0.9412 0.9412 0.9412];
            app.MagnifyKnob.Value = 1;

            % Create EditField
            app.EditField = uieditfield(app.GridLayout, 'text');
            app.EditField.Editable = 'off';
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.FontColor = [0.9412 0.9412 0.9412];
            app.EditField.BackgroundColor = [0.502 0.502 0.502];
            app.EditField.Layout.Row = 8;
            app.EditField.Layout.Column = [1 4];
            app.EditField.Value = 'Emir Tarık Arıcı EE 101 Project 2';

            % Create DurationLabel
            app.DurationLabel = uilabel(app.GridLayout);
            app.DurationLabel.HorizontalAlignment = 'center';
            app.DurationLabel.FontColor = [0.9412 0.9412 0.9412];
            app.DurationLabel.Layout.Row = 7;
            app.DurationLabel.Layout.Column = 1;
            app.DurationLabel.Text = 'Duration';

            % Create DurationSlider
            app.DurationSlider = uislider(app.GridLayout);
            app.DurationSlider.Limits = [0 15];
            app.DurationSlider.Layout.Row = 7;
            app.DurationSlider.Layout.Column = [2 7];
            app.DurationSlider.FontColor = [0.9412 0.9412 0.9412];
            app.DurationSlider.Value = 2;

            % Create EditField_2
            app.EditField_2 = uieditfield(app.GridLayout, 'text');
            app.EditField_2.Editable = 'off';
            app.EditField_2.HorizontalAlignment = 'center';
            app.EditField_2.FontColor = [0.9412 0.9412 0.9412];
            app.EditField_2.BackgroundColor = [0.502 0.502 0.502];
            app.EditField_2.Layout.Row = 8;
            app.EditField_2.Layout.Column = [5 6];
            app.EditField_2.Value = 'Özyeğin University';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = EmirTarik_Arici_EE101_TermProject2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end