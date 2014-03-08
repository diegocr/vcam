
ARCH    = mingw32
PROGRAM = VCam
TARGET  = $(PROGRAM).ax
CC      = $(ARCH)-gcc
CXX     = $(ARCH)-g++
STRIP   = $(ARCH)-strip
RM      = rm -f
CFLAGS  = -O2 -mwindows -Iinclude
LIBS    = -lole32 -luuid -loleaut32 -lwinmm -lstrmiids
LDFLAGS = -shared $(CFLAGS)
OBJDIR  = .objs$(ARCH)

INSTALL_PATH = "C:\\WINDOWS\\System32\\"

OBJS = \
	$(OBJDIR)/Dll.o \
	$(OBJDIR)/Filters.def \
	$(OBJDIR)/Filters.o \
	$(OBJDIR)/mbase_dllentry.o \
	$(OBJDIR)/mbase_amfilter.o \
	$(OBJDIR)/mbase_amvideo.o \
	$(OBJDIR)/mbase_wxutil.o \
	$(OBJDIR)/mbase_wxlist.o \
	$(OBJDIR)/mbase_combase.o \
	$(OBJDIR)/mbase_dllsetup.o \
	$(OBJDIR)/mbase_mtype.o \
	$(OBJDIR)/mbase_source.o

all:	$(OBJDIR) $(TARGET)

$(OBJDIR):
	mkdir -p $@

$(OBJDIR)/%.o: %.c
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: %.cpp
	@echo Compiling $@
	@$(CXX) $(CFLAGS) -fpermissive -c $< -o $@

$(TARGET): $(OBJS)
	@echo Linking $@
	$(CXX) -o $@ $(LDFLAGS) $(OBJS) $(LIBS) $(LIBSX)
	@$(STRIP) $@

$(OBJDIR)/%.def: makefile
	@echo Creating $@
	@echo 'LIBRARY	"$(TARGET)"' >$@
	@echo 'EXPORTS' >>$@
	@echo 'DllMain PRIVATE' >>$@
	@echo 'DllGetClassObject PRIVATE' >>$@
	@echo 'DllCanUnloadNow PRIVATE' >>$@
	@echo 'DllRegisterServer PRIVATE' >>$@
	@echo 'DllUnregisterServer PRIVATE' >>$@

install: $(OBJDIR) $(TARGET)
	@echo Installing $(TARGET)...
	@cp $(TARGET) $(INSTALL_PATH)

clean:
	$(RM) -r $(OBJDIR)
	$(RM) ./*.ax
