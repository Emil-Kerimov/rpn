# frozen_string_literal: true

def priority(operation)
  case operation
  when '+', '-'
    return 1
  when '*', '/'
    return 2
  else
    return 0
  end
end

def is_operator?(char)
  ['+', '-', '*', '/'].include?(char)
end

def rpn(expression)
  output = []
  stack = []

  expression.scan(/\d+|[+\-*\/()]/).each do |char|
    if char =~ /\d+/
      output << char
    elsif is_operator?(char)
      while !stack.empty? && priority(stack.last) >= priority(char)
        output << stack.pop
      end
      stack.push(char)
    elsif char == '('
      stack.push(char)
    elsif char == ')'
      while stack.last != '('
        output << stack.pop
      end
      stack.pop
    end
  end

  while !stack.empty?
    output << stack.pop
  end

  output.join(' ')
end

input = ARGV.join(' ')
puts rpn(input)
