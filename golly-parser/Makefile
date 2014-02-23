# build directories
BIN_DIR := ./bin
JC := javac
JFLAGS := -g
ANTLR := antlr4

GRAMMAR := golly_rle.g4
GOLLY_ANTLR_JAVA := golly_rleLexer.java \
                    golly_rleBaseListener.java \
                    golly_rleListener.java \
                    golly_rleParser.java
GOLLY_ANTLR := $(GOLLY_ANTLR_JAVA) \
               golly_rle.tokens \
               golly_rleLexer.tokens
GOLLY_TEST_JAVA := BailErrorStrategy.java \
                   golly_rleReader.java


default: $(BIN_DIR) golly_antlr_classes

$(GOLLY_ANTLR): $(GRAMMAR)
	$(ANTLR) $(GRAMMAR)

golly_antlr_classes: $(GOLLY_ANTLR)
	$(JC) $(JFLAGS) $(GOLLY_ANTLR_JAVA) -d $(BIN_DIR)

$(BIN_DIR):
	mkdir -p $@

test: golly_antlr_classes $(GOLLY_TEST_JAVA)
	$(JC) $(JFLAGS) $(GOLLY_TEST_JAVA) -d $(BIN_DIR)

clean:
	rm -f $(BIN_DIR)/*.class
	rm -f $(GOLLY_ANTLR)
