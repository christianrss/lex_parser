%{
// Code declarations/definitions

// All data structures BEGIN
// All data structures END

// Global variables BEGIN
extern "C" int yylex();
extern char lex_buffer[512];

char lex_buffer[512];
// Global variables END

#include "MexprEnums.h"

%}

%%
\n {
	return PARSER_EOL;
}

0|-?[1-9][0-9]* {
	return MATH_CPP_INT;
}

-?[0-9]*\.[0-9]+ {
	return MATH_CPP_DOUBLE;
}

[a-zA-Z0-9_]+ {
	return MATH_CPP_VARIABLE;
}

(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]) {
    return MATH_CPP_IPV4;
}

[ ] {

}

. {
	printf("ignore non-parsable character - %s\n", yytext);
}

%%

int main(int argc, char **argv) {
	
	while(1) {
		fgets(lex_buffer, sizeof(lex_buffer), stdin);
		if (lex_buffer[0] == '\n') {
			lex_buffer[0] = 0;
			continue;
		}

		yy_scan_string(lex_buffer);

		int token_code;
		token_code = yylex();
		
		while(token_code!=PARSER_EOL) {
			printf("token_code=%d, token=%s, token_len=%d\n", token_code, yytext, yyleng);
			token_code = yylex();
		}
	}

	return 0;

}
