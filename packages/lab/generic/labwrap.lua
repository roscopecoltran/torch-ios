require 'wrap'

local interface = wrap.CInterface.new()

interface:print('/* WARNING: autogenerated file */')
interface:print()

local reals = {ByteTensor='byte',
               CharTensor='char',
               ShortTensor='short',
               IntTensor='int',
               LongTensor='long',
               FloatTensor='float',
               DoubleTensor='double'}

for _,Tensor in ipairs({"ByteTensor", "CharTensor",
                            "ShortTensor", "IntTensor", "LongTensor",
                            "FloatTensor", "DoubleTensor"}) do

   local real = reals[Tensor]

   function interface.luaname2wrapname(self, name)
      return string.format('lab_%s_%s', Tensor, name)
   end

   local function cname(name)
      return string.format('TH%sLab_%s', Tensor:gsub('Tensor', ''), name)
   end

   local function lastdim(argn)
      return function(arg)
                return string.format("TH%s_nDimension(%s)", Tensor, arg.args[argn]:carg())
             end
   end
   
   interface:wrap("zero",
                  cname("zero"),
                  {{name=Tensor, returned=true}})

   interface:wrap("fill",
                  cname("fill"),
                  {{name=Tensor, returned=true},
                   {name=real}})

   interface:wrap("dot",
                  cname("dot"),
                  {{name=Tensor},
                   {name=Tensor},
                   {name=real, creturned=true}})

   for _,name in ipairs({"minall", "maxall", "sumall"}) do
      interface:wrap(name,
                     cname(name),
                     {{name=Tensor},            
                      {name=real, creturned=true}})
   end

   interface:wrap("add",
                  cname("add"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real}},
                  cname("cadd"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real, default=1},
                   {name=Tensor}})

   interface:wrap("mul",
                  cname("mul"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real}})

   interface:wrap("div",
                  cname("div"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real}})

   interface:wrap("cmul",
                  cname("cmul"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=Tensor}})

   interface:wrap("cdiv",
                  cname("cdiv"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=Tensor}})

   interface:wrap("addcmul",
                  cname("addcmul"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real, default=1},
                   {name=Tensor},
                   {name=Tensor}})

   interface:wrap("addcdiv",
                  cname("addcdiv"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=real, default=1},
                   {name=Tensor},
                   {name=Tensor}})

   for _,name in ipairs({"addmv", "addmm", "addr"}) do
      interface:wrap(name,
                     cname(name),
                     {{name=Tensor, default=true, returned=true},
                      {name=real, default=1},
                      {name=Tensor},
                      {name=real, default=1},
                      {name=Tensor},
                      {name=Tensor}})
   end

   interface:wrap("numel",
                  cname("numel"),
                  {{name=Tensor},
                   {name=real, creturned=true}})

   for _,name in ipairs({"sum", "prod", "cumsum", "cumprod"}) do
      interface:wrap(name,
                     cname(name),
                     {{name=Tensor, default=true, returned=true},
                      {name=Tensor},
                      {name="index", default=lastdim(2)}})
   end

   interface:wrap("min",
                  cname("min"),
                  {{name=Tensor, default=true, returned=true},
                   {name="IndexTensor", default=true, returned=true},
                   {name=Tensor},
                   {name="index", default=lastdim(3)}})

   interface:wrap("max",
                  cname("max"),
                  {{name=Tensor, default=true, returned=true},
                   {name="IndexTensor", default=true, returned=true},
                   {name=Tensor},
                   {name="index", default=lastdim(3)}})

   interface:wrap("trace",
                  cname("trace"),
                  {{name=Tensor},
                   {name=real, creturned=true}})

   interface:wrap("cross",
                  cname("cross"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=Tensor},
                   {name="index", default=lastdim(2)}})

   interface:wrap("diag",
                  cname("diag"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name="long", default=0}})

   interface:wrap("eye",
                  cname("eye"),
                  {{name=Tensor, default=true, returned=true},
                   {name="long"},
                   {name="long", default=0}})

   interface:wrap("range",
                  cname("range"),
                  {{name=Tensor, default=true, returned=true},
                   {name=real},
                   {name=real},
                   {name=real, default=1}})

   interface:wrap("randperm",
                  cname("randperm"),
                  {{name=Tensor, default=true, returned=true, userpostcall=function(arg)
                                                                              return string.format("TH%s_add(%s);", Tensor:gsub('Tensor', 'Lab'), arg:carg())
                                                                           end},
                   {name="long"}})

   interface:wrap("sort",
                  cname("sort"),
                  {{name=Tensor, default=true, returned=true},
                   {name="IndexTensor", default=true, returned=true},
                   {name=Tensor},
                   {name="index", default=lastdim(3)},
                   {name="boolean", default=0}})


   interface:wrap("tril",
                  cname("tril"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name="int", default=0}})

   interface:wrap("triu",
                  cname("triu"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name="int", default=0}})

   interface:wrap("cat",
                  cname("cat"),
                  {{name=Tensor, default=true, returned=true},
                   {name=Tensor},
                   {name=Tensor},
                   {name="index", default=lastdim(2)}})

   if Tensor == 'FloatTensor' or Tensor == 'DoubleTensor' then

      interface:wrap("mean",
                     cname("mean"),
                     {{name=Tensor, default=true, returned=true},
                      {name=Tensor},
                      {name="index", default=lastdim(2)}})

      interface:wrap("std",
                     cname("std"),
                     {{name=Tensor, default=true, returned=true},
                      {name=Tensor},
                      {name="index", default=lastdim(2)},
                      {name="boolean", default=false}})

      interface:wrap("var",
                     cname("var"),
                     {{name=Tensor, default=true, returned=true},
                      {name=Tensor},
                      {name="index", default=lastdim(2)},
                      {name="boolean", default=false}})

      interface:wrap("norm",
                     cname("norm"),
                     {{name=Tensor},
                      {name=real, default=2},
                      {name=real, creturned=true}})

      interface:wrap("dist",
                     cname("dist"),
                     {{name=Tensor},
                      {name=Tensor},
                      {name=real, default=2},
                      {name=real, creturned=true}})

      for _,name in ipairs({"meanall", "varall", "stdall"}) do
         interface:wrap(name,
                        cname(name),
                        {{name=Tensor},
                         {name=real, creturned=true}})
      end

      interface:wrap("linspace",
                     cname("linspace"),
                     {{name=Tensor, default=true, returned=true},
                      {name=real},
                      {name=real},
                      {name="long", default=100}})

      interface:wrap("logspace",
                     cname("logspace"),
                     {{name=Tensor, default=true, returned=true},
                      {name=real},
                      {name=real},
                      {name="long", default=100}})

      for _,name in ipairs({"log", "log1p", "exp",
                            "cos", "acos", "cosh",
                            "sin", "asin", "sinh",
                            "tan", "atan", "tanh",
                            "sqrt",
                            "ceil", "floor",
                            "abs"}) do

         interface:wrap(name,
                        cname(name),
                        {{name=Tensor, default=true, returned=true},
                         {name=Tensor}},
                        name,
                        {{name=real},
                         {name=real, creturned=true}})
         
      end

      interface:wrap("pow",
                     cname("pow"),
                     {{name=Tensor, default=true, returned=true},
                      {name=Tensor},
                      {name=real}},
                     "pow",
                     {{name=real},
                      {name=real},
                      {name=real, creturned=true}})

   end

   interface:register(string.format("%s_stuff", Tensor))

end
print(interface:text())
