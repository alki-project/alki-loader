Alki::Loader.register '../files/one.rb', builder: 'example_builder', name: 'example/files/one'
Alki::Loader.register '../files', name: 'example/files'
Alki::Loader.register 'example/files', builder: 'example_builder'
Alki::Loader.register 'example/files2', builder: 'example_builder'
