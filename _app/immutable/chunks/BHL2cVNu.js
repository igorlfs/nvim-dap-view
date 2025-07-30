import"./Bzak7iHL.js";import"./mWcOREWt.js";import{f as t,s as c,b as r,a as D}from"./Dt_WvEws.js";import{h as y}from"./D1NPPRhA.js";import{l as i,s as F}from"./DcJdz_br.js";import{M as C}from"./BH-zKbrT.js";const a={title:"Configuration"},{title:_}=a;var A=t('<h2 id="defaults"><a href="#defaults">Defaults</a></h2> <p>These are the default options from <code>nvim-dap-view</code>. You can use them as reference. You don’t have to copy-paste them.</p> <!>',1);function m(n,l){const p=i(l,["children","$$slots","$$events","$$legacy"]);C(n,F(()=>p,()=>a,{children:(o,E)=>{var s=A(),e=c(r(s),4);y(e,()=>`<pre class="shiki catppuccin-mocha" style="background-color:#1e1e2e;color:#cdd6f4" tabindex="0"><code><span class="line"><span style="color:#CBA6F7">return</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">    winbar </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">        show </span><span style="color:#94E2D5">=</span><span style="color:#F38BA8"> true</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">        -- You can add a "console" section to merge the terminal with the other views</span></span>
<span class="line"><span style="color:#CDD6F4">        sections </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123; </span><span style="color:#A6E3A1">"watches"</span><span style="color:#CDD6F4">, </span><span style="color:#A6E3A1">"scopes"</span><span style="color:#CDD6F4">, </span><span style="color:#A6E3A1">"exceptions"</span><span style="color:#CDD6F4">, </span><span style="color:#A6E3A1">"breakpoints"</span><span style="color:#CDD6F4">, </span><span style="color:#A6E3A1">"threads"</span><span style="color:#CDD6F4">, </span><span style="color:#A6E3A1">"repl" </span><span style="color:#CDD6F4">&#125;,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">        -- Must be one of the sections declared above (except for "console")</span></span>
<span class="line"><span style="color:#CDD6F4">        default_section </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "watches"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">        -- Configure each section individually</span></span>
<span class="line"><span style="color:#CDD6F4">        base_sections </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">            breakpoints </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "B"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Breakpoints [B]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> " [B]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.views"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">switch_to_view</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"breakpoints"</span><span style="color:#CDD6F4">)</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            scopes </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "S"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Scopes [S]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󰂥 [S]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.views"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">switch_to_view</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"scopes"</span><span style="color:#CDD6F4">)</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            exceptions </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "E"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Exceptions [E]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󰢃 [E]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.views"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">switch_to_view</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"exceptions"</span><span style="color:#CDD6F4">)</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            watches </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "W"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Watches [W]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󰛐 [W]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.views"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">switch_to_view</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"watches"</span><span style="color:#CDD6F4">)</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            threads </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "T"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Threads [T]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󱉯 [T]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.views"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">switch_to_view</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"threads"</span><span style="color:#CDD6F4">)</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            repl </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "R"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "REPL [R]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󰯃 [R]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.repl"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">show</span><span style="color:#CDD6F4">()</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            console </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                keymap </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "C"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "Console [C]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                short_label </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "󰆍 [C]"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                action</span><span style="color:#94E2D5"> =</span><span style="color:#CBA6F7"> function</span><span style="color:#9399B2">()</span></span>
<span class="line"><span style="color:#89B4FA;font-style:italic">                    require</span><span style="color:#CDD6F4">(</span><span style="color:#A6E3A1">"dap-view.term"</span><span style="color:#CDD6F4">).</span><span style="color:#89B4FA;font-style:italic">show</span><span style="color:#CDD6F4">()</span></span>
<span class="line"><span style="color:#CBA6F7">                end</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">        &#125;,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">        -- Add your own sections</span></span>
<span class="line"><span style="color:#CDD6F4">        custom_sections </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;&#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">        controls </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">            enabled </span><span style="color:#94E2D5">=</span><span style="color:#F38BA8"> false</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            position </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "right"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            buttons </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#A6E3A1">                "play"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "step_into"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "step_over"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "step_out"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "step_back"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "run_last"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "terminate"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#A6E3A1">                "disconnect"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            icons </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">                play </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                pause </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                step_into </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                step_over </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                step_out </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                step_back </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                run_last </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                terminate </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">                disconnect </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> ""</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">            custom_buttons </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;&#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">        &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">    &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">    windows </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">        height </span><span style="color:#94E2D5">=</span><span style="color:#FAB387"> 0.25</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">        position </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "below"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">        terminal </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">            width </span><span style="color:#94E2D5">=</span><span style="color:#FAB387"> 0.5</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">            position </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "left"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">            -- List of debug adapters for which the terminal should be ALWAYS hidden</span></span>
<span class="line"><span style="color:#CDD6F4">            hide </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;&#125;,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">            -- Hide the terminal when starting a new session</span></span>
<span class="line"><span style="color:#CDD6F4">            start_hidden </span><span style="color:#94E2D5">=</span><span style="color:#F38BA8"> false</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">        &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">    &#125;,</span></span>
<span class="line"><span style="color:#CDD6F4">    help </span><span style="color:#94E2D5">=</span><span style="color:#CDD6F4"> &#123;</span></span>
<span class="line"><span style="color:#CDD6F4">        border </span><span style="color:#94E2D5">=</span><span style="color:#F38BA8"> nil</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">    &#125;,</span></span>
<span class="line"><span style="color:#6C7086;font-style:italic">    -- Controls how to jump when selecting a breakpoint or navigating the stack</span></span>
<span class="line"><span style="color:#CDD6F4">    switchbuf </span><span style="color:#94E2D5">=</span><span style="color:#A6E3A1"> "usetab"</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">    auto_toggle </span><span style="color:#94E2D5">=</span><span style="color:#F38BA8"> false</span><span style="color:#CDD6F4">,</span></span>
<span class="line"><span style="color:#CDD6F4">&#125;</span></span></code></pre>`),D(o,s)},$$slots:{default:!0}}))}export{m as default,a as metadata};
