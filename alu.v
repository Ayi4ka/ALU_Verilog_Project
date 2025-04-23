module alu #(parameter WIDTH = 8)(
    input  wire [WIDTH-1:0] A,        // Первый операнд
    input  wire [WIDTH-1:0] B,        // Второй операнд
    input  wire [3:0] op_code,        // Код операции
    output reg  [WIDTH-1:0] result,   // Результат операции
    output reg  zero,                 // Флаг нуля
    output reg  negative,             // Флаг отрицательного результата
    output reg  carry,                // Флаг переноса
    output reg  overflow              // Флаг переполнения
);

    reg [WIDTH:0] tmp_result; // Регистр с дополнительным битом для учёта переноса
    reg signed [WIDTH-1:0] A_signed, B_signed, result_signed;

    always @(*) begin
        // Обнуление флагов и переменных
        carry     = 0;
        overflow  = 0;
        zero      = 0;
        negative  = 0;
        result    = 0;
        tmp_result = 0;

        A_signed = A;
        B_signed = B;

        case(op_code)
            4'b0000: begin // ADD: сложение
                tmp_result = A + B;
                result     = tmp_result[WIDTH-1:0];
                carry      = tmp_result[WIDTH]; // перенос из старшего разряда
                overflow   = (~A[WIDTH-1] & ~B[WIDTH-1] & result[WIDTH-1]) |
                             (A[WIDTH-1] & B[WIDTH-1] & ~result[WIDTH-1]);
            end

            4'b0001: begin // SUB: вычитание
                tmp_result = A - B;
                result     = tmp_result[WIDTH-1:0];
                carry      = A < B; // признак заёма
                overflow   = (A[WIDTH-1] & ~B[WIDTH-1] & ~result[WIDTH-1]) |
                             (~A[WIDTH-1] & B[WIDTH-1] & result[WIDTH-1]);
            end

            4'b0010: begin // AND: побитовое И
                result = A & B;
                carry = 0;
                overflow = 0;
            end

            4'b0011: begin // OR: побитовое ИЛИ
                result = A | B;
                carry = 0;
                overflow = 0;
            end

            4'b0100: begin // XOR: исключающее ИЛИ
                result = A ^ B;
                carry = 0;
                overflow = 0;
            end

            4'b0101: begin // SHL: сдвиг влево
                tmp_result = {A, 1'b0};  // оценка переноса
                result = A << 1;
                carry = A[WIDTH-1];      // старший бит "вылетает"
                overflow = (A[WIDTH-1] != result[WIDTH-1]); // меняется знак
            end

            4'b0110: begin // SHR: сдвиг вправо (логический)
                result = A >> 1;
                carry = A[0];            // младший бит "вылетает"
                overflow = 0;            // логический сдвиг не вызывает переполнения
            end

            4'b0111: begin // MUL: умножение (младшие биты в результат)
                tmp_result = A * B;
                result = tmp_result[WIDTH-1:0];
                carry = tmp_result[WIDTH]; // оценка переполнения как "перенос"
                overflow = tmp_result[WIDTH]; // если старший бит не влез
            end

            default: begin
                result = 0;
                carry = 0;
                overflow = 0;
            end
        endcase

        // Установка флагов результата
        zero     = (result == 0);        // Если результат — ноль
        negative = result[WIDTH-1];      // Если результат отрицательный (старший бит 1)
    end

endmodule
