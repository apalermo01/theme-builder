import logging
from tempfile import mkstemp
from os import remove
from shutil import move

logger = logging.getLogger(__name__)



def replace_line(file: str,
                 pattern: str,
                 new_line: str):
    """
    Function that replaces the given line in the given file.

    :param file: file to modify.
    :param pattern: pattern to filter.
    :param new_line: line to replace with.
    """
    pattern_found = False
    fh, abs_path = mkstemp()
    with fdopen(fh, 'w') as new_file:
        with open(file) as old_file:
            for line in old_file:
                if line.startswith(pattern):
                    pl1 = line
                    pl1 = pl1.rstrip()
                    pl2 = new_line
                    pl2 = pl2.rstrip()
                    logger.warning('Replacing line: \'%s\' with \'%s\'', pl1, pl2)
                    pattern_found = True
                    try:
                        new_file.write(new_line + '\n')
                    except IOError:
                        logger.error('Failed!')
                else:
                    try:
                        new_file.write(line)
                    except IOError:
                        )                            logger.error('Failed!')
    remove(file)
    move(abs_path, file)
    return pattern_found
