% test AnalysisfMRI

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

sub11 = SubjectfMRI('ID11', 'label 11', 'notes 11', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub12 = SubjectfMRI('ID12', 'label 12', 'notes 12', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub13 = SubjectfMRI('ID13', 'label 13', 'notes 13', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub14 = SubjectfMRI('ID14', 'label 14', 'notes 14', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));

group1 = Group('SubjectfMRI', 'group 1 id', 'group 1 label', 'group 1 notes', {sub11, sub12, sub13, sub14}, 'GroupName', 'GroupTestfMRI1');

sub21 = SubjectfMRI('ID21', 'label 21', 'notes 21', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub22 = SubjectfMRI('ID22', 'label 22', 'notes 22', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub23 = SubjectfMRI('ID23', 'label 23', 'notes 23', atlas, 'age', 15, 'fMRI', .5 + .5 * rand(atlas.getBrainRegions().length()));

group2 = Group('SubjectfMRI', 'group 2 id', 'group 2 label', 'group 2 notes', {sub21, sub22, sub23}, 'GroupName', 'GroupTestfMRI2');

cohort = Cohort('Cohort fMRI', 'cohort label', 'cohort notes', 'SubjectfMRI', atlas, {sub11, sub12, sub13, sub14, sub21, sub22, sub23});
cohort.getGroups().add(group1.getID(), group1)
cohort.getGroups().add(group2.getID(), group2)

graph_type = AnalysisfMRI.getGraphType();
measures = Graph.getCompatibleMeasureList(graph_type);

%% Test 1: Instantiation
analysis = AnalysisfMRI('analysis id', 'analysis label', 'analysis notes', cohort, {}, {}, {}); %#ok<NASGU>

%% Test 2: Create correct ID
analysis = AnalysisfMRI('analysis id', 'analysis label', 'analysis notes', cohort, {}, {}, {});

measurement_id = analysis.getMeasurementID('Degree', group1);
expected_value = [ ...
    tostring(analysis.getMeasurementClass()) ' ' ...
    tostring('Degree') ' ' ...
    tostring(analysis.getCohort().getGroups().getIndex(group1)) ...
    ];
assert(ischar(measurement_id), ...
    [BRAPH2.STR ':AnalysisfMRI:' BRAPH2.WRONG_OUTPUT], ...
    'AnalysisfMRI.getMeasurementID() not creating an ID')
assert(isequal(measurement_id, expected_value), ...
    [BRAPH2.STR ':AnalysisfMRI:' BRAPH2.WRONG_OUTPUT], ...
    'AnalysisfMRI.getMeasurementID() not creating correct ID')

% randomcomparison_id = analysis.getRandomComparisonID('PathLength', group1);
% expected_value = [ ...
%     tostring(analysis.getRandomComparisonClass()) ' ' ...
%     tostring('PathLength') ' ' ...
%     tostring(analysis.getCohort().getGroups().getIndex(group1)) ...
%     ];
% assert(ischar(randomcomparison_id), ...
%     [BRAPH2.STR ':AnalysisMRI:getRandomComparisonID'], ...
%     ['AnalysisMRI.getRandomComparisonID() not creating an ID']) %#ok<*NBRAK>
% assert(isequal(randomcomparison_id, expected_value), ...
%     [BRAPH2.STR ':AnalysisMRI:getRandomComparisonID'], ...
%     ['AnalysisMRI.getRandomComparisonID() not creating correct ID']) %#ok<*NBRAK>

% comparison_id = analysis.getComparisonID('Distance', {group1, group2});
% expected_value = [ ...
%     tostring(analysis.getComparisonClass()) ' ' ...
%     tostring('Distance') ' ' ...
%     tostring(analysis.getCohort().getGroups().getIndex(group1)) ' ' ...
%     tostring(analysis.getCohort().getGroups().getIndex(group2)) ...
%     ];
% assert(ischar(comparison_id), ...
%     [BRAPH2.STR ':AnalysisMRI:getComparisonID'], ...
%     ['AnalysisMRI.getComparisonID() not creating an ID']) %#ok<*NBRAK>
% assert(isequal(comparison_id, expected_value), ...
%     [BRAPH2.STR ':AnalysisMRI:getComparisonID'], ...
%     ['AnalysisMRI.getComparisonID() not creating correct ID']) %#ok<*NBRAK>

%% Test 3: Calculate Measurement
for i = 1:1:length(measures)
    measure = measures{i};
    analysis = AnalysisfMRI('analysis id', 'analysis label', 'analysis notes', cohort, {}, {}, {});
    calculated_measurement = analysis.getMeasurement(measure, group1);
    
    assert(~isempty(calculated_measurement), ...
        [BRAPH2.STR ':AnalysisfMRI:' BRAPH2.BUG_FUNC], ...
        'AnalysisfMRI.getMeasurement() not working')
    
    measurement_keys = analysis.getMeasurements().getKeys();
    
    for j = 1:1:numel(measurement_keys)
        calculated_measurement = analysis.getMeasurements().getValue(measurement_keys{j});
        calculated_value = calculated_measurement.getMeasureValues();
        
        if Measure.is_global(measure)
            
            assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
                [BRAPH2.STR ':AnalysisfMRI:calculateMeasurement'], ...
                ['AnalysisfMRI.calculateMeasurement() not working for global']) %#ok<*NBRAK>
            assert(iscell(calculated_value) & ...
                isequal(numel(calculated_value), group1.subjectnumber) & ...
                all(cellfun(@(x) isequal(size(x), [1, 1]), calculated_value)), ...
                [BRAPH2.STR ':AnalysisfMRI:Instantiation'], ...
                ['AnalysisfMRI does not initialize correctly with global measures.']) %#ok<*NBRAK>
            
        elseif Measure.is_nodal(measure)
            
            assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
                [BRAPH2.STR ':AnalysisfMRI:calculateMeasurement'], ...
                ['AnalysisfMRI.calculateMeasurement() not working for nodal']) %#ok<*NBRAK>
            assert(iscell(calculated_value) & ...
                isequal(numel(calculated_value), group1.subjectnumber) & ...
                all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), calculated_value)), ...
                [BRAPH2.STR ':AnalysisfMRI:Instantiation'], ...
                ['AnalysisfMRI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
        
        elseif Measure.is_binodal(measure)
            
            assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
                [BRAPH2.STR ':AnalysisfMRI:calculateMeasurement'], ...
                ['AnalysisfMRI.calculateMeasurement() not working for binodal']) %#ok<*NBRAK>
            assert(iscell(calculated_value) & ...
                isequal(numel(calculated_value), group1.subjectnumber) & ...
                all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), calculated_value)), ...
                [BRAPH2.STR ':AnalysisfMRI:Instantiation'], ...
                ['AnalysisfMRI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
        end
    end
end
 
%% Test 4: Random Compare
% for i = 1:1:numel(measures)
%     measure = measures{i};
%     analysis = AnalysisMRI(cohort, {}, {}, {});
%     number_of_permutations = 10;
%     calculate_comparison = analysis.calculateRandomComparison(measure, group1, 'NumerOfPermutations', number_of_permutations);
%     
%     assert(~isempty(calculate_comparison), ...
%         [BRAPH2.STR ':AnalysisMRI:calculateComparison'], ...
%         ['AnalysisMRI.calculateComparison() not working']) %#ok<*NBRAK>
%     
%     assert(analysis.getRandomComparisons().length() == 1, ...
%         [BRAPH2.STR ':AnalysisMRI:calculateComparison'], ...
%         ['AnalysisMRI.calculateComparison() not working'])
%     
%     comparison = analysis.getRandomComparisons().getValue(1);
%     comparison_values_1 = comparison.getGroupValue();
%     comparison_values_2 = comparison.getRandomValue();
%     comparison_difference = comparison.getDifference();
%     comparison_all_differences = comparison.getAllDifferences();
%     comparison_p1 = comparison.getP1();
%     comparison_p2 = comparison.getP2();
%     comparison_confidence_interval_min = comparison.getConfidenceIntervalMin();
%     comparison_confidence_interval_max = comparison.getConfidenceIntervalMax();
%     
%     if Measure.is_global(measures{i})
%         assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_1)) & ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with global measures.']) %#ok<*NBRAK>
%         assert(isequal(numel(comparison_difference), 1) & ...
%             isequal(numel(comparison_all_differences), number_of_permutations) & ...
%             isequal(numel(comparison_p1), 1) & ...
%             isequal(numel(comparison_p2), 1) & ...
%             isequal(numel(comparison_confidence_interval_min), 1) & ...
%             isequal(numel(comparison_confidence_interval_max), 1), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with global measures.']) %#ok<*NBRAK>
%     elseif Measure.is_nodal(measures{i})
%         assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_1)) & ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
%         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
%             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), 1]), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
%     elseif Measure.is_binodal(measures{i})
%        assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_1)), ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
%         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
%             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
%     end
% end

%% Test 4: Compare
% for i = 1:1:numel(measures)
%     measure = measures{i};
%     analysis = AnalysisMRI(cohort, {}, {}, {});
%     number_of_permutations = 10;
%     calculate_comparison = analysis.calculateComparison(measure, {group1, group2}, 'NumerOfPermutations', number_of_permutations);
%     
%     assert(~isempty(calculate_comparison), ...
%         [BRAPH2.STR ':AnalysisMRI:calculateComparison'], ...
%         ['AnalysisMRI.calculateComparison() not working']) %#ok<*NBRAK>
%     
%     assert(analysis.getComparisons().length() == 1, ...
%         [BRAPH2.STR ':AnalysisMRI:calculateComparison'], ...
%         ['AnalysisMRI.calculateComparison() not working'])
%     
%     comparison = analysis.getComparisons().getValue(1);
%     comparison_values_1 = comparison.getGroupValue(1);
%     comparison_values_2 = comparison.getGroupValue(2);
%     comparison_difference = comparison.getDifference();
%     comparison_all_differences = comparison.getAllDifferences();
%     comparison_p1 = comparison.getP1();
%     comparison_p2 = comparison.getP2();
%     comparison_confidence_interval_min = comparison.getConfidenceIntervalMin();
%     comparison_confidence_interval_max = comparison.getConfidenceIntervalMax();
%     
%     if Measure.is_global(measures{i})
%         assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_1)) & ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with global measures.']) %#ok<*NBRAK>
%         assert(isequal(numel(comparison_difference), 1) & ...
%             isequal(numel(comparison_all_differences), number_of_permutations) & ...
%             isequal(numel(comparison_p1), 1) & ...
%             isequal(numel(comparison_p2), 1) & ...
%             isequal(numel(comparison_confidence_interval_min), 1) & ...
%             isequal(numel(comparison_confidence_interval_max), 1), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with global measures.']) %#ok<*NBRAK>
%     elseif Measure.is_nodal(measures{i})
%         assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_1)) & ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
%         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
%             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), 1]), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
%     elseif Measure.is_binodal(measures{i})
%        assert(iscell(comparison_values_1) & ...
%             isequal(numel(comparison_values_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_1)), ...
%             iscell(comparison_values_2) & ...
%             isequal(numel(comparison_values_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_values_2)), ...
%             [BRAPH2.STR ':MeasurementMRI:Instantiation'], ...
%             ['MeasurementMRI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
%         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
%             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
%             [BRAPH2.STR ':AnalysisMRI:Instantiation'], ...
%             ['AnalysisMRI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
%     end
% end