% test ComparisonCON_BUT

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

subject_class = Comparison.getSubjectClass('ComparisonCON_BUT');

sub1 = Subject.getSubject(subject_class, 'id1', 'label 1', 'notes 1', atlas);
sub2 = Subject.getSubject(subject_class, 'id2', 'label 2', 'notes 2', atlas);
sub3 = Subject.getSubject(subject_class, 'id3', 'label 3', 'notes 3', atlas);
sub4 = Subject.getSubject(subject_class, 'id4', 'label 4', 'notes 4', atlas);
sub5 = Subject.getSubject(subject_class, 'id5', 'label 5', 'notes 5', atlas);

group = Group(subject_class, 'id', 'label', 'notes', {sub1, sub2, sub3, sub4, sub5});

graph_type = AnalysisCON_BUT.getGraphType();
measures = Graph.getCompatibleMeasureList(graph_type);

%% Test 1: Instantiation
for i = 1:1:numel(measures)
    comparison = ComparisonCON_BUT('c1', 'label', 'notes', atlas, measures{i}, group, group);
end

%% Test 2: Correct Size defaults
for i = 1:1:numel(measures)
    number_of_permutations = 10;
    
    comparison = ComparisonCON_BUT('c1', 'label', 'notes', atlas, measures{i}, group, group, 'ComparisonCON.PermutationNumber', number_of_permutations);
    
    values = comparison.getGroupValue(1);    
    values_2 = comparison.getGroupValue(2); 
    average_values_1 = comparison.getGroupAverageValue(1);
    average_values_2 = comparison.getGroupAverageValue(2);
    difference = comparison.getDifference();  % difference
    all_differences = comparison.getAllDifferences(); % all differences obtained through the permutation test
    p1 = comparison.getP1(); % p value single tailed
    p2 = comparison.getP2();  % p value double tailed
    confidence_interval_min = comparison.getConfidenceIntervalMin();  % min value of the 95% confidence interval
    confidence_interval_max = comparison.getConfidenceIntervalMax(); % max value of the 95% confidence interval
    
    if Measure.is_global(measures{i})
        
        assert(iscell(values) && ...
            isequal(numel(values), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), values)),  ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
                
        assert(iscell(values_2) && ...
            isequal(numel(values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
 
        assert(iscell(average_values_1) && ...
            isequal(numel(average_values_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), average_values_1)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(average_values_2) && ...
            isequal(numel(average_values_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), average_values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), difference)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), all_differences)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), p1)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
    elseif Measure.is_nodal(measures{i})
        
        assert(iscell(values) && ...
            isequal(numel(values), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), values)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(values_2) && ...
            isequal(numel(values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), values_2)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(average_values_1) && ...
            isequal(numel(average_values_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), average_values_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(average_values_2) && ...
            isequal(numel(average_values_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), average_values_2)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), difference)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), all_differences)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), p1)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
    elseif Measure.is_binodal(measures{i})
      
        assert(iscell(values) && ...
            isequal(numel(values), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), values)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(values_2) && ...
            isequal(numel(values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(average_values_1) && ...
            isequal(numel(average_values_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), average_values_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(average_values_2) && ...
            isequal(numel(average_values_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), average_values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), difference)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), all_differences)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), p1)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
    end
end

%% Test 3: Initialize with values
for i = 1:1:numel(measures)
    % setup
    number_of_permutations = 10;
    
    % the values are not realistic, just the right format
    for j = 1:1:group.subjectnumber()
        A = rand(atlas.getBrainRegions().length());
        g = Graph.getGraph('GraphWU', A);
        m  = Measure.getMeasure(measures{i}, g);
        values{j} =  cell2mat(m.getValue());
    end
    
    average_values = {mean(reshape(cell2mat(values), [size(values{1}, 1), size(values{1}, 2), group.subjectnumber()]), 3)};
    
    difference  = average_values;
    all_differences = repmat(values(1), 1, number_of_permutations);
    p1 = difference;  % all similar
    p2 = difference;
    confidence_interval_min = difference;
    confidence_interval_max = difference;
    
        % act
    comparison = ComparisonCON_BUT('c1', ...
        'comparison label', ...
        'comparison notes', ...
        atlas, ...
        measures{i}, ...
        group, ...
        group, ...
        'ComparisonCON.PermutationNumber', number_of_permutations, ...
        'ComparisonCON.values_1', values, ...
        'ComparisonCON.values_2', values, ...
        'ComparisonCON.average_values_1', average_values, ...
        'ComparisonCON.average_values_2', average_values, ...
        'ComparisonCON.difference', difference, ...
        'ComparisonCON.all_differences', all_differences, ...
        'ComparisonCON.p1', p1, ...
        'ComparisonCON.p2', p2, ....
        'ComparisonCON.confidence_min', confidence_interval_min, ...
        'ComparisonCON.confidence_max', confidence_interval_max ...
        );
    
    comparison_values_1 = comparison.getGroupValue(1);
    comparison_values_2 = comparison.getGroupValue(2);
    comparison_average_1 = comparison.getGroupAverageValue(1);
    comparison_average_2 = comparison.getGroupAverageValue(2);
    comparison_difference = comparison.getDifference();
    comparison_all_differences = comparison.getAllDifferences();
    comparison_p1 = comparison.getP1();
    comparison_p2 = comparison.getP2();
    comparison_confidence_interval_min = comparison.getConfidenceIntervalMin();
    comparison_confidence_interval_max = comparison.getConfidenceIntervalMax();
    
    % assert
    if Measure.is_global(measures{i})
        assert(iscell(comparison_values_1) && ...
            isequal(numel(comparison_values_1), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_values_2) && ...
            isequal(numel(comparison_values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_average_1) && ...
            isequal(numel(comparison_average_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_average_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_average_2) && ...
            isequal(numel(comparison_average_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_average_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
       
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_difference)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_all_differences)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_p1)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with global measures')
        
    elseif Measure.is_nodal(measures{i})
       
       assert(iscell(comparison_values_1) && ...
            isequal(numel(comparison_values_1), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_values_2) && ...
            isequal(numel(comparison_values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_2)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_average_1) && ...
            isequal(numel(comparison_average_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_average_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_average_2) && ...
            isequal(numel(comparison_average_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_average_2)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_difference)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_all_differences)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_p1)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with nodal measures')
        
    elseif Measure.is_binodal(measures{i})
 
      assert(iscell(comparison_values_1) && ...
            isequal(numel(comparison_values_1), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_values_2) && ...
            isequal(numel(comparison_values_2), group.subjectnumber()) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
 
        assert(iscell(comparison_average_1) && ...
            isequal(numel(comparison_average_1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_average_1)) , ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_average_2) && ...
            isequal(numel(comparison_average_2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_average_2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_difference)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), number_of_permutations) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_all_differences)), ...        
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_p1)), ...        
            [BRAPH2.STR ':AnalysisMRI:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonMRI does not initialize correctly with binodal measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_p2)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), 1) && ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonCON_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonCON_BUT does not initialize correctly with binodal measures')        
    end 
end