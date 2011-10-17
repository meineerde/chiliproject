module ChiliProject
  module QueryLanguage
    def self.source
      File.dirname(__FILE__) + "/query_language/query_language_parser.tt"
    end

    def self.compile!
      compiler = Treetop::Compiler::GrammarCompiler.new
      compiler.compile(source)
    end

    def self.reload!
      Treetop.load(source)
    end
  end
end