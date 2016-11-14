package Kent::Lexer::Keywords;
use common::sense;

our @keywords = (

    # Builtin functions that are also methods for some Types.
    qw/ sprintf say print select open /,

    # Types
    qw/ Number Object String Boolean True False Array Hash Collection Regex
        Handle Exception Role /,

    # scoping and encapsulation
    qw/ secret private protected public export ro /,

    # Methods for all objects
    qw/ roles has with refcount reference undef default /,

    # Handle methods
    # XXX: This needs research, thought, and planning.
    qw/ opened close fileno mode irs ors autoflush eof fcntl getc ioctl read
        sysread syswrite truncate /,

    # Methods for Strings, Numbers, Arrays, Hashes, and Collections
    qw/ each map rmap grep rgrep /,

    # Methods for Strings, Arrays, and Hashes
    qw/ reverse /,

    # Methods for Numbers
    qw/ str times /,

    # Methods for Strings
    qw/ num length append prepend split /,

    # Methods for Arrays, Hashes, and Collections
    qw/ count /,

    # Methods for Hashes and Collections
    qw/ keys values /,

    # Methods for Arrays and Collections
    qw/ join shift unshift push pop insert delete indexes /,

    # Roles
    qw/ role private const /,

    # Loop constructs
    qw/ for while until last next redo /,

    # Conditionals
    qw/ if then else elseif unless given when final /,

    # Exceptions
    qw/ must throw trap except /,

    # Variables inside special code blocks
    qw/ key value args a b i /,

    # Reserved for the sake of being reserved
    qw/ package pkg /, );
1;
