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
  previous_char = nil

  expression.scan(/-?\d+\.\d+|-?\d+|[+\-*\/()]/).each do |char|
    if char =~ /-?\d+/ || char =~ /-?\d+\.\d+/
      output << char
    elsif char == '-' && (previous_char.nil? || is_operator?(previous_char) || previous_char == '(')
      output << char + expression.scan(/-?\d+\.\d+|-?\d+/).first
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
    previous_char = char
  end

  while !stack.empty?
    output << stack.pop
  end

  output.join(' ')
end

def evaluate_rpn(rpn_expression)
  stack = []

  rpn_expression.split.each do |element|
    if element =~ /-?\d+/ || element =~ /-?\d+\.\d+/
      stack.push(element.to_f)
    elsif is_operator?(element)
      if stack.size < 2
        raise ArgumentError, "Некоректний вираз '#{element}'"
      end

      b = stack.pop
      a = stack.pop
      case element
      when '+'
        stack.push(a + b)
      when '-'
        stack.push(a - b)
      when '*'
        stack.push(a * b)
      when '/'
        raise ZeroDivisionError, "Помилка! Ділення на нуль" if b == 0
        stack.push(a / b)
      end
    end
  end

  if stack.size != 1
    raise ArgumentError, "Помилка у записі виразу"
  end

  stack.pop
end

input = ARGV.join(' ')

if input =~ /[^0-9+\-*\/().\s]/
  puts "Ошибка: обнаружен некорректный символ."
else
  rpn_expression = rpn(input)
  begin
    result = evaluate_rpn(rpn_expression)
    puts "RPN: #{rpn_expression}"
    puts "Результат: #{result}"
  rescue ZeroDivisionError => e
    puts e.message
  rescue ArgumentError => e
    puts e.message
  end
end
