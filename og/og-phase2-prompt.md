yea get started on step 2, follow the same protocal for writing out pahse 1:

Example guide I really like: https://dev.to/simplr_sh/nextjs-15-app-router-seo-comprehensive-checklist-3d3f

Why I like it:
- Sectioned into phases that make sense
- The steps (1., 2., 3. ... 11., 12.,) are complete sentences that tell you what to do
- Inside each step includes the WHY and the HOW. The WHY is the technical decision, the HOW is the technical execution, and then the optional LEARN MORE with any links

## Format

### [Step number]. [Complete sentence describing what to do]

**Why:** The technical decision — why this choice was made, including any personal preferences and when it's okay to deviate.

**How:** The technical execution — either a numbered list of UI steps or a code block with the commands to run.

**Learn More:** [Optional] Links to relevant docs or resources.



the new protocals phase 2 shoudl include two commands, the first being the one to create the schema + types, the second shoudl eb the one to make the plan file.


the first step in pahse 1 shoudl be to fill out the @docs/01-goal.md 

The second step shoudl be to define the schema and tyeps fromt eh goal. this shoudl evoke a command

the first command for defining the schema and types shoudl essentially be this part of the protocol:

Need to build out schema, types. Everything. This step is the **entire architecture**. It needs to be done completely.

Write it all to an SQL file that I will run in the **Supabase SQL Editor**. Consider:

- Tables with NOT NULL and unique constraints
- Foreign keys with ON DELETE CASCADE
- RLS policies per table
- Any Postgres functions (e.g. abbreviations)
- Generate sample data and put it into an SQL file that I will run in the Supabase SQL Editor

4. Add to `package.json` → "supabase gen types typescript --project-id [project-id] > app/types/database.ts"
   - `-y5`


Plus any deep researhc you find from https://shiptypes.com/

Read everythign thoroughly


the thirs step in pahse 1 shoudl eb make the plan. that shoudl essentailly eb this command:

Thoroughly read all of `docs/01-goal.md` and `app/types/database.ts` to understand what the [project] should  
  do and all its specificities.                                                                                         
                                                                                                                        
  When that's done, research the technologies used further - next.js and supabase - use context7 to help research.      
                                                                                                                        
  Then, write an iterative, simple, and concise 02-plan.md with the following steps, and differentiate when I need to   
  do something manually (supabase GUI) and when you (Claude) can do something.                                          
                                                                                                                        
  First, we need to worry about the skeleton and auth - like setting up src/lib/supabase/client.ts and                  
  /supabase/server.ts ( createBrowserClient<database> and createServerClient<database> )                                
                                                                                                                        
  For auth, keep it super simple and follow supabase best practices via supabase auth - one server action, two fields,  
  done simply.                                                                                                          
                                                                                                                        
                                                                                                                        
  Then, let's focus on the main read path - a test for connecting next and supabase, real data in the browser. I want   
  to see all existing data on the homescreen as a server component, query supabase directly. No need for loading        
  states, client hooks, or abstractions yet.                                                                            
                                                                                                                        
  Then, main write path — core mutations end to end. Build the server action for the thing theater times actually does, 
   replacing the "existing data" with the new data, and then maybe an RPC function so the old data is turned into an    
  archived data object with a timestamp.                                                                                
                                                                                                                        
  All data is owned by us, so trust the generated types. No zod needed.                                                 
                                                                                                                        
  Need to be able to submit the form, open supabase, see in the table editor changes were made, confirm the row exists, 
   and then come back to browser and confirm it renders.                                                                
                                                                                                                        
  Once that is done, let's focus on the secondary surfaces and features like the editing of the data in the data        
  normalization screen. Focus on this feature here and only here. I imagine the flow is submit data -> server           
  normalizes via RPC function -> user views the first draft of normalized data client side -> user makes changes that   
  persist client side -> when submitting/approving, server action handles the data mutation, and rpc function controls  
  the change from "new data in, existing data archived".                                                                
                                                                                                                        
  After the secondary features are created, let's do a pass of styling (layout, typography, one accent color). No       
  component library, simple if any design system.                                                                       
                                                                                                                        
  Then create a suite of end-to-end walkthroughs to manually test. 



So to recap this long prompt:


read ship types and the prompts, polish the rompts into commands, write the command sto claude/commands, write otu the steps in the why how learn mroe moremat in @buuld-protocol.md
