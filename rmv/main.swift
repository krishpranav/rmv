//
//  main.swift
//  rmv
//
//  Created by Elangovan Ayyasamy on 08/08/21.
//

import Cocoa

let currnet = NSURL.fileURL(withPath: ".")
let parent = NSURL.fileURL(withPath: "..")

do
{
    let args = try Arguments(ProcessInfo.processInfo.arguments)
    
    
    if args.files.count == 0
    {
        print( args.usage() ?? "No files provided" )
        exit( -1 )
    }
}

catch Arguments.Error.RuntimeError(let message)
{
    print(message)
    exit(-1)
}
