# build directories
BIN_DIR := ./bin
JC := javac
JFLAGS := -g
ANTLR := antlr4

GRAMMAR := GollyRle.g4
GOLLY_ANTLR_JAVA := GollyRleLexer.java \
                    GollyRleBaseListener.java \
                    GollyRleListener.java \
                    GollyRleParser.java
GOLLY_ANTLR := $(GOLLY_ANTLR_JAVA) \
               GollyRle.tokens \
               GollyRleLexer.tokens
GOLLY_TEST_JAVA := BailErrorStrategy.java \
                   GollyRleReader.java \
                   GollyRleFileLoader.java \
                   GollyRleManualInput.java \
                   GollyBatchTester.java


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
