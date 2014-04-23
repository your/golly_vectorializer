import golly as g
import os.path

# default base path as the Desktop, change it if needed
default_path = os.path.expanduser('~/Desktop')
# default name is the current pattern name without extension
pattern_name = g.getname().split('.')[0]
# getting an output path
export_path = g.savedialog('Choose the directory and name',
                           'All files (*)|*',
                           default_path,
                           pattern_name)
if export_path == "":
    export_path = default_path

# number of generations
num_generations = 10

# has a selection been made?
selected = 1 if len(g.getselrect()) > 0 else 0

for i in range(num_generations):
    # advance by one generation (checking if something is selected)
    if selected == 1:
        g.advance(0, 1)
    else:
        g.run(1)
    # export to a new file
    file_path = '%s-%d.rle' % (export_path, i)
    g.show(file_path)
    g.save(file_path, 'rle')
