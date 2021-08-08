//
//  Arguments.swift
//  rmv
//
//  Created by Elangovan Ayyasamy on 08/08/21.
//

import Foundation


class Arguments
{
    public private( set ) var directories = false
    public private( set ) var force       = false
    public private( set ) var interactive = false
    public private( set ) var recursive   = false
    public private( set ) var verbose     = false
    public private( set ) var files       = [ String ]()
    
    public init( _ arguments: [ String ] ) throws
    {
        if arguments.count < 2
        {
            throw Error.RuntimeError( self.usage() ?? "Unknown error" )
        }
        
        for arg in arguments.dropFirst()
        {
            if arg.hasPrefix( "-" ) && FileManager.default.fileExists( atPath: arg )
            {
                self.files.append( arg )
            }
            else if arg.hasPrefix( "-" ) && self.files.count > 0
            {
                throw Error.RuntimeError( self.usage() ?? "Invalid arguments" )
            }
            else if arg.hasPrefix( "-" )
            {
                let index = arg.index( arg.startIndex, offsetBy: 1 )
                let args  = arg[ index... ]
                
                for c in args
                {
                    if c == "d"
                    {
                        self.directories = true
                    }
                    else if c == "f"
                    {
                        self.interactive = false
                        self.force       = true
                    }
                    else if c == "i"
                    {
                        self.interactive = true
                        self.force       = false
                    }
                    else if c == "R" || c == "r"
                    {
                        self.recursive = true
                    }
                    else if c == "v"
                    {
                        self.verbose = true
                    }
                    else
                    {
                        throw Error.RuntimeError( "Unrecognized argument \( arg )" )
                    }
                }
            }
            else
            {
                self.files.append( arg )
            }
        }
    }
}
