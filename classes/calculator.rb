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
        def fn?
            precedence == :fn
        end
    end

    Operators = {
        '-u'   => Operator.new(5,   lambda {|a| -1 * a}, :right),
        '^'    => Operator.new(3,   lambda {|a,b| a ** b}, :right),
        '*'    => Operator.new(2,   lambda {|a,b| a * b}),
        '/'    => Operator.new(2,   lambda {|a,b| Float(a) / b}),
        'sin'  => Operator.new(:fn, lambda {|a| Math.sin(a)}),
        'cos'  => Operator.new(:fn, lambda {|a| Math.cos(a)}),
        'tan'  => Operator.new(:fn, lambda {|a| Math.tan(a)}),
        'sqrt' => Operator.new(:fn, lambda {|a| Math.sqrt(a)}),
        'log'  => Operator.new(:fn, lambda {|a,b| Math.log(a,b)}),
        '+'    => Operator.new(1,   lambda {|a,b| a + b}),
        '-'    => Operator.new(1,   lambda {|a,b| a - b})
    }

    Delimiters = ['(', ')', ','].concat(Operators.keys)
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

                    op = Operators[token]
                    op2 = Operators[operators.last]

                    if !op.fn? && op2 && op < op2
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
                    
                    if (operators.last && Operators[operators.last].fn?)
                        expression << operators.pop
                    end

                elsif token == ","
                    until operators.last == "("
                        expression << operators.pop
                    end
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
