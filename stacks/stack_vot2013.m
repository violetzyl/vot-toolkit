function experiments = stack_vot2013()

print_text('');
print_text(' **** Deprecation warning **** ');
print_text('Note that VOT2013 benchmark is deprecated.');
print_text('You can still use it, the toolkit may no longer produce results that are the same as in the challenge paper.');
print_text('');

set_global_variable('bundle', 'http://data.votchallenge.net/vot2013/dataset/description.json');
set_global_variable('legacy_rasterization', true);
set_global_variable('bounded_overlap', false);

baseline.name = 'baseline';
baseline.converter = [];
baseline.type = 'supervised';
baseline.tags = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};
baseline.parameters.repetitions = 15;
baseline.parameters.burnin = 10;
baseline.parameters.skip_initialize = 5;
baseline.parameters.failure_overlap = 0;
baseline.analysis = {'ar_rank', 'speed'};

region_noise.name = 'region_noise';
region_noise.converter = @(sequence) sequence_transform_initialization(...
    sequence, @noisy_transform, 'rectangle');
region_noise.type = 'supervised';
region_noise.tags = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};
region_noise.parameters.repetitions = 15;
region_noise.parameters.burnin = 10;
region_noise.parameters.skip_initialize = 5;
region_noise.parameters.failure_overlap = 0;
region_noise.analysis = {'ar_rank', 'speed'};

grayscale.name = 'grayscale';
grayscale.converter = 'sequence_grayscale';
grayscale.type = 'supervised';
grayscale.tags = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};
grayscale.parameters.repetitions = 15;
grayscale.parameters.burnin = 10;
grayscale.parameters.skip_initialize = 5;
grayscale.parameters.failure_overlap = 0;
grayscale.analysis = {'ar_rank', 'speed'};

experiments = {baseline, region_noise, grayscale};

end

function [transform] = noisy_transform(sequence, index, context)

    bounds = region_convert(sequence_get_region(sequence, index), 'rectangle');

    scale = 0.9 + rand(1, 2) * 0.2;
    move = bounds(3:4) .* (0.1 - rand(1, 2) * 0.2);

    transform = [scale(1), 0, move(1); 0, scale(2), move(2); 0, 0, 1];

end
