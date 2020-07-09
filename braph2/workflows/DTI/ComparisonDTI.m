classdef ComparisonDTI < Comparison
    properties
        values_1  % array with the values_1 of the measure for each subject of group 1
        values_2  % array with the values_1 of the measure for each subject of group 1
        average_value_1  % average value of group 1
        average_value_2  % average value of group 1
        difference  % difference
        all_differences  % all differences obtained through the permutation test
        p1  % p value single tailed
        p2  % p value double tailed
        confidence_interval_min  % min value of the 95% confidence interval
        confidence_interval_max  % max value of the 95% confidence interval
    end
    methods  % Constructor
        function c =  ComparisonDTI(id, label, notes, atlas, measure_code, group_1, group_2, varargin)
            
% TODO: Add assert that the measure_code is in the measure list.

            c = c@Comparison(id, label, notes, atlas, measure_code, group_1, group_2, varargin{:});
        end
    end
    methods  % Get functions        
        function [values_1, values_2] = getGroupValues(c)
            values_1 = c.values_1;
            values_2 = c.values_2;
        end
        function values = getGroupValue(c, group_index)
            if group_index == 1
                values = c.values_1;
            else
                values = c.values_2;
            end
        end
        function [average_value_1, average_value_2] = getGroupAverageValues(c)
            average_value_1 = c.average_value_1;
            average_value_2 = c.average_value_2;
        end
        function average_value = getGroupAverageValue(c, group_index)
            if group_index == 1
                average_value = c.average_value_1;
            else
                average_value = c.average_value_2;
            end
        end
        function difference = getDifference(c)
            difference = c.difference;
        end
        function all_differences = getAllDifferences(c)
            all_differences = c.all_differences;
        end
        function p1 = getP1(c)
            p1 = c.p1;
        end
        function p2 = getP2(c)
            p2 = c.p2;
        end
        function confidence_interval_min = getConfidenceIntervalMin(c)
            confidence_interval_min = c.confidence_interval_min;
        end
        function confidence_interval_max = getConfidenceIntervalMax(c)
            confidence_interval_max = c.confidence_interval_max;
        end
    end
    methods (Access=protected)  % Initialize data
        function initialize_data(c, varargin)
            atlases = c.getBrainAtlases();
            atlas = atlases{1};
            [group_1, group_2]  = c.getGroups();
            
            measure_code = c.getMeasureCode();
            
            number_of_permutations = c.getSettings('ComparisonDTI.PermutationNumber');
            
            if Measure.is_global(measure_code)  % global measure
                % values
                c.values_1 = get_from_varargin( ...
                    {0}, 1, group_1.subjectnumber(), ...
                    'ComparisonDTI.values_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group_1.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])  %#ok<*NBRAK>
                
                c.values_2 = get_from_varargin( ...
                    {0}, 1, group_2.subjectnumber(), ...
                    'ComparisonDTI.values_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group_2.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                % average values
                c.average_value_1 = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.average_values_1', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(1)), [1, 1]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.average_value_2 = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.average_values_2', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(2)), [1, 1]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                % statistic measures
                c.difference = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({0}, 1, number_of_permutations), ...
                    'ComparisonDTI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.p1 = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.p2 = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.confidence_min', ...
                    varargin{:});
                
                c.confidence_interval_max = get_from_varargin( ...
                    0, ...
                    'ComparisonDTI.confidence_max', ...
                    varargin{:});             
                
            elseif Measure.is_nodal(measure_code)  % nodal measure
                c.values_1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, 1, group_1.subjectnumber(), ...
                    'ComparisonDTI.values_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group_1.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.values_2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, 1, group_2.subjectnumber(), ...
                    'ComparisonDTI.values_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group_2.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.average_value_1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.average_values_1', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(1)), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.average_value_2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.average_values_2', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(2)), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                % statistic values
                c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, number_of_permutations), ...
                    'ComparisonDTI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.confidence_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonDTI.confidence_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
            elseif Measure.is_binodal(measure_code)  % binodal measure
                c.values_1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, 1, group_1.subjectnumber(), ...
                    'ComparisonDTI.values_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group_1.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.values_2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, 1, group_2.subjectnumber(), ...
                    'ComparisonDTI.values_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group_2.subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.average_value_1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.average_values_1', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(1)), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                c.average_value_2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.average_values_2', ...
                    varargin{:});
                assert(isequal(size(c.getGroupAverageValue(2)), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2.WRONG_INPUT], ...
                    ['Data not compatible with ComparisonDTI.'])
                
                % statistic values
                c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.difference', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                              
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, number_of_permutations), ...
                    'ComparisonDTI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                             
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.confidence_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonDTI.confidence_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonDTI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonDTI')           
            end
        end
    end
    methods (Static)  % Descriptive functions
        function class = getClass() 
            class = 'ComparisonDTI';
        end
        function name = getName()
            name = 'Comparison DTI';
        end
        function description = getDescription()
            description = 'DTI comparison';
        end
        function atlas_number = getBrainAtlasNumber()
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass()
            analysis_class = 'AnalysisDTI';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectDTI';
        end
        function available_settings = getAvailableSettings()
            available_settings = {
                'ComparisonDTI.PermutationNumber', BRAPH2.NUMERIC, 1000, {};
                };
        end
        function sub = getComparison(comparisonClass, id, label, notes, atlas, measure_code, group_1, group_2, varargin) %#ok<INUSD>
            sub = eval([comparisonClass '(id, label, notes, atlas, measure_code, group_1, group_2, varargin{:})']);
        end
    end
end