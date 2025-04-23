`timescale 1ns / 1ps

module alu_tb;

    reg  [7:0] A, B;
    reg  [3:0] op_code;
    wire [7:0] result;
    wire zero, negative, carry, overflow;

    // Подключение ALU
    alu #(8) dut (
        .A(A),
        .B(B),
        .op_code(op_code),
        .result(result),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin
        // Установка файла для вывода изменений сигналов
        $dumpfile("alu_wave.vcd");       // имя файла 
        $dumpvars(0, alu_tb);            // сохранить все сигналы текущего модуля

        // Заголовок и мониторинг
        $display("Time |  A  |  B  | OP  | Result | Z | N | C | O ");
        $monitor("%4dns | %3d | %3d | %2h  | %3d    | %b | %b | %b | %b",
                 $time, A, B, op_code, result, zero, negative, carry, overflow);

        // Тест 1: ADD
        A = 8'd100; B = 8'd55; op_code = 4'b0000; #10;

        // Тест 2: SUB
        A = 8'd30; B = 8'd100; op_code = 4'b0001; #10;

        // Тест 3: AND
        A = 8'b10101010; B = 8'b11001100; op_code = 4'b0010; #10;

        // Тест 4: OR
        A = 8'b10100000; B = 8'b00001111; op_code = 4'b0011; #10;

        // Тест 5: XOR
        A = 8'b11110000; B = 8'b00001111; op_code = 4'b0100; #10;

        // Тест 6: SHL
        A = 8'b10000001; B = 0; op_code = 4'b0101; #10;

        // Тест 7: SHR
        A = 8'b00000011; B = 0; op_code = 4'b0110; #10;

        // Тест 8: MUL
        A = 8'd15; B = 8'd15; op_code = 4'b0111; #10;

        $finish;
    end

endmodule
