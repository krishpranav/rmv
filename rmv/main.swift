//
//  main.swift
//  rmv
//
//  Created by Elangovan Ayyasamy on 08/08/21.
//

import Cocoa

let current = NSURL.fileURL( withPath: "." )
let parent  = NSURL.fileURL( withPath: ".." )

do
{
    let args = try Arguments( ProcessInfo.processInfo.arguments )
    
    if args.files.count == 0
    {
        print( args.usage() ?? "No files provided" )
        exit( -1 )
    }
    
    for file in args.files
    {
        var isDir: ObjCBool = false
        
        if file.utf8.count == 0
        {
            print( "rm: empty file path" )
            exit( -1 )
        }
        
        let path = ( NSString( string: file ).expandingTildeInPath as NSString ).standardizingPath as String
        
        if path.utf8.count == 0
        {
            print( "rm: empty file path" )
            exit( -1 )
        }
        
        let exists = FileManager.default.fileExists( atPath: path, isDirectory: &isDir )
        let url    = NSURL( fileURLWithPath: path, isDirectory: isDir.boolValue ) as URL
        
        if exists == false
        {
            if args.force == false
            {
                print( "rm: \( file ): No such file or directory" )
                exit( -1 )
            }
            
            continue;
        }
        
        if url.path == current.path || url.path == parent.path
        {
            print( "rm: \".\" and \"..\" may not be removed" )
            exit( -1 )
        }
        
        if isDir.boolValue
        {
            if args.directories == false && args.recursive == false
            {
                print( "rm: \( file ): is a directory" )
                exit( -1 )
            }
            
            do
            {
                let isEmpty = try FileManager.default.contentsOfDirectory( at: url, includingPropertiesForKeys: [], options: .skipsSubdirectoryDescendants ).count == 0
                
                if isEmpty == false && args.recursive == false
                {
                    print( "rm: \( file ): Directory not empty" )
                    exit( -1 )
                }
            }
            catch
            {
                print( "rm: \( file ): Cannot list directory" )
                exit( -1 )
            }
        }
        
        if args.interactive
        {
            print( "remove \( file )? ", terminator: "" )
            
            let input = readLine() ?? "n"
            
            if input.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines).lowercased() != "y"
            {
                exit( -1 )
            }
        }
        
        do
        {
            try FileManager.default.trashItem( at: url, resultingItemURL: nil )
        }
        catch
        {
            print( "rm: \( file ): Cannot move to trash" )
            exit( -1 )
        }
    }
}
catch Arguments.Error.RuntimeError( let message )
{
    print( message )
    exit( -1 )
}
