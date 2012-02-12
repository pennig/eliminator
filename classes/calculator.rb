
module Calculator

    def Calculator.calculate(expression)
        rpn = RPNCalculator.new(expression)
        rpn.value
    end

    #

    Operator = Struct.new(:precedence, :fn, :associativity)
    class Operator
      def <(other)
        if associativity == :right
          precedence < other.precedence
        else 
          precedence <= other.precedence
        end
      end
    end

    Operators = {
    	'-u'  => Operator.new(9, lambda {|a| -1 * a}, :right),
    	'^'   => Operator.new(5, lambda {|a,b| a ** b}, :right),
    	'*'   => Operator.new(4, lambda {|a,b| Float(a) * b}),
    	'/'   => Operator.new(4, lambda {|a,b| Float(a) / b}),
    	'sin' => Operator.new(3, lambda {|a| Math.sin(a)}),
    	'cos' => Operator.new(3, lambda {|a| Math.cos(a)}),
    	'tan' => Operator.new(3, lambda {|a| Math.tan(a)}),
    	'+'   => Operator.new(2, lambda {|a,b| a + b}),
    	'-'   => Operator.new(2, lambda {|a,b| a - b})
    }

    Delimiters = ['(', ')'].concat(Operators.keys)
    InfixTokenizer = Regexp.new('('+Delimiters.map {|d| Regexp.escape(d)}.join('|')+')')

    class RPNCalculator
        def initialize(infix)
            infix.gsub!(/\s+/, '')
            tokens = infix.split(InfixTokenizer).reject {|t| t.size==0 }

            expression = []
            operators = []
            token = nil
            last_token = nil

            until tokens.empty?
                last_token = token
                token = tokens.shift
            
                if Operators[token]
            
                    #handle unary negation
                    if token == '-' && (last_token.nil? || last_token == '(' || Operators[last_token])
                        token = '-u'
                    end
            
                    op = operators.last
                    if Operators[op] && Operators[token] < Operators[op]
                        expression << operators.pop
                    end
                    operators << token
                
                elsif token == "("
                    operators << token
                
                elsif token == ")"
                    until operators.last == "("
                        expression << operators.pop
                    end
                    operators.pop
            
                else
                    expression << token
                end
            end
            until operators.empty?
                expression << operators.pop
            end

            @expression = expression
        end

        def value
            values = []
            @expression.each do |term|
                if Operators.has_key?(term)
                    fn = Operators[term].fn
                    args = values.pop(fn.arity)
                    values.push(fn.call(*args))
                else
                    term = term.match('.') ? Float(term) : Integer(term)
                    values.push(term)
                end
            end

            values.pop
        end
    end
end

puts Calculator.calculate("-3 + 5 * -5 / (-2 + 4)")