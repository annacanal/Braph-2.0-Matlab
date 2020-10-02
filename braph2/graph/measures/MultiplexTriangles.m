classdef MultiplexTriangles < Measure
    % MultiplexTriangles Multiplex Triangles measure
    % MultiplexTriangles provides the number of triangles of a node for binary
    % undirected (BU), binary directed (BD), weighted undirected (WU) and 
    % weighted directed (WD) graphs. 
    %
    % It is calculated as the number of a node's neighbor pairs that are   
    % connected to each other within two layers. In weighted graphs, the triangles are 
    % calculated as geometric mean of the weights of the edges forming
    % the triangle. For directed graphs the user can set the rule to
    % calculate the triangles (setting 'DirectedTrianglesRule').
    % 
    % MultiplexTriangles methods:
    %   MultiplexTriangles          - constructor
    %
    % MultiplexTriangles methods (Static)
    %   getClass                    - returns the triangles class
    %   getName                     - returns the name of triangles measure
    %   getDescription              - returns the description of triangles measure
    %   getAvailableSettings        - returns the settings available to the class
    %   getMeasureFormat            - returns the measure format
    %   getMeasureScope             - returns the measure scope
    %   getParametricity            - returns the parametricity of the measure
    %   getMeasure                  - returns the triangles class
    %   getCompatibleGraphList      - returns a list of compatible graphs
    %   getCompatibleGraphNumber    - returns the number of compatible graphs
    %
    % See also Measure, Graph, MultiplexGraphBU, MultiplexGraphWU.
    
    methods
        function m = MultiplexTriangles(g, varargin)  
            % MULTIPLEXTRIANGLES(G) creates triangles with default properties.
            % G is a graph (e.g, an instance of MultiplexGraphBD,
            % MultiplexGraphBU, MultiplexGraphWD or MultiplexGraphWU).  
            %
            % MULTIPLEXTRIANGLES(G, 'DirectedTrianglesRule', DIRECTEDTRIANGLESRULE) creates triangles             
            % measure and initializes the property DirectedTrianglesRule with DIRECTEDTRIANGLESRULE. 
            % Admissible RULE options are:
            % DIRECTEDTRIANGLESRULE = 'cycle' (default) - calculates TRIANGLES of a node using the cycle rule for directed graphs.
            %                    'all' - calculates TRIANGLES of a node
            %                    using the all rule for directed graphs.
            %                    'middleman' - calculates TRIANGLES of a
            %                    node using the middleman rule for directed graphs.
            %                    'in' - calculates TRIANGLES of a node
            %                    using the in rule for directed graphs.
            %                    'out' - calculates TRIANGLES of a node
            %                    using the out rule for directed graphs.
            %           
            % MULTIPLEXTRIANGLES(G, 'VALUE', VALUE) creates triangles, and sets the value
            % to VALUE. G is a graph (e.g, an instance of MultiplexGraphBD,
            % MultiplexGraphBU, MultiplexGraphWD or MultiplexGraphWU). 
            %   
            % See also Measure, Graph, MultiplexGraphBU, MultiplexGraphBD, MultiplexGraphWU, MultiplexGraphWD.
            
            m = m@Measure(g, varargin{:});
        end
    end
    methods (Access=protected)
        function multiplex_triangles = calculate(m)
            % CALCULATE calculates the number of triangles of a node
            %
            % TRIANGLES = CALCULATE(M) returns the triangles 
            % of a node.
            %
            % See also Measure, Graph, GraphBU, GraphBD, GraphWU, GraphWD, MultiplexGraphBU, MultiplexGraphBD, MultiplexGraphWU, MultiplexGraphWD.
            
            g = m.getGraph();  % graph from measure class
            A = g.getA();  % adjency matrix of the graph
            L = g.layernumber();

            multiplex_triangles_layers = get_from_varargin([1, 2], 'MultiplexTrianglesLayers', m.getSettings());
            assert(length(multiplex_triangles_layers) == 2, ...
                [BRAPH2.STR ':MultiplexTriangles' BRAPH2.WRONG_INPUT], ...
                ['Multiplex triangles layers must contain the index of ' ...
                'two layers (' tostring(L) ') while it contains ' tostring(length(multiplex_triangles_layers))])
            assert(all(ismember(multiplex_triangles_layers, 1:L)), ...
                [BRAPH2.STR ':MultiplexTriangles:' BRAPH2.WRONG_INPUT], ...
                ['Multiplex triangles layers indexes must be integers and be between 1 and the ' ...
                'number of layers (' tostring(L) ') while they are ' tostring(multiplex_triangles_layers)])          
            
            A11 = A{multiplex_triangles_layers(1), multiplex_triangles_layers(1)};
            A22 = A{multiplex_triangles_layers(2), multiplex_triangles_layers(2)};
            multiplex_triangles = {diag(A11.^(1/3)*A22.^(1/3)*A11.^(1/3)) + diag(A22.^(1/3)*A11.^(1/3)*A22.^(1/3))};
        end
    end
    methods (Static)
        function measure_class = getClass()
            % GETCLASS returns the measure class 
            %            
            % MEASURE_CLASS = GETCLASS() returns the class of the multiplex triangles measure.
            %
            % See also getName(), getDescription(). 
            
            measure_class = 'MultiplexTriangles';
        end
        function name = getName()
            % GETNAME returns the measure name
            %
            % NAME = GETNAME() returns the name of the multiplex triangles measure.
            %
            % See also getClass(), getDescription(). 
            
            name = 'Multiplex triangles';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the triangles description 
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description of the
            % multiplex triangles measure.
            %
            % See also getClass, getName.
            
            description = [ ...
                'The multiplex triangles of a node are ' ...
                'the number of its neighbor pairs' ...
                'that are connected to each other within a layer. ' ...
                'In weighted graphs, the triangles are calculated' ...
                'as geometric mean of the weights of the edges' ...
                'forming the triangle.' ...
                ];
        end
        function available_settings = getAvailableSettings()
            % GETAVAILABLESETTINGS returns the setting available to
            % MultiplexTriangles
            %
            % AVAILABLESETTINGS = GETAVAILABLESETTINGS() returns the
            % settings available to MultiplexTriangles. 
            % MULTIRPLEXTRIANGLESLAYERS = [1, 2] (default) - MULTIPLEXTRIANGLES  
            %                    layers' indexes will be set to 1 and 2.
            %                    values - MULTIPLEXTRIANGLES layers' indexes 
            %                    will be set to the values specified if the 
            %                    values are integers between 1 and the
            %                    number of layers.

            available_settings = {
                 'MultiplexTrianglesLayers', BRAPH2.NUMERIC, [1, 2], {};
                };
        end
        function measure_format = getMeasureFormat()
            % GETMEASUREFORMAT returns the measure format of MultiplexTriangles
            %
            % MEASURE_FORMAT = GETMEASUREFORMAT() returns the measure format
            % of triangles measure (NODAL).
            %
            % See also getMeasureScope.
            
            measure_format = Measure.NODAL;
        end
        function measure_scope = getMeasureScope()
            % GETMEASURESCOPE returns the measure scope of MultiplexTriangles
            %
            % MEASURE_SCOPE = GETMEASURESCOPE() returns the
            % measure scope of multiplex triangles measure (SUPERGLOBAL).
            %
            % See also getMeasureFormat.
            
            measure_scope = Measure.SUPERGLOBAL;
        end
        function parametricity = getParametricity()
            % GETPARAMETRICITY returns the parametricity of MultiplexTriangles
            %
            % PARAMETRICITY = GETPARAMETRICITY() returns the
            % parametricity of multiplex triangles measure (NONPARAMETRIC).
            %
            % See also getMeasureFormat, getMeasureScope.
            
            parametricity = Measure.NONPARAMETRIC;
        end
        function list = getCompatibleGraphList()
            % GETCOMPATIBLEGRAPHLIST returns the list of compatible graphs
            % with MultiplexTriangles 
            %
            % LIST = GETCOMPATIBLEGRAPHLIST() returns a cell array 
            % of compatible graph classes to multiplex triangles. 
            % The measure will not work if the graph is not compatible. 
            %
            % See also getCompatibleGraphNumber(). 
                      
            list = { ...
                'MultiplexGraphBU', ...
                'MultiplexGraphWU' ...
                };
        end
        function n = getCompatibleGraphNumber()
            % GETCOMPATIBLEGRAPHNUMBER returns the number of compatible
            % graphs with MultiplexTriangles 
            %
            % N = GETCOMPATIBLEGRAPHNUMBER() returns the number of
            % compatible graphs to multiplex triangles.
            % 
            % See also getCompatibleGraphList().
            
            n = Measure.getCompatibleGraphNumber('MultiplexTriangles');
        end
    end
end
